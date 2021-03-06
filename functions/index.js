const functions = require('firebase-functions');
const admin = require('firebase-admin');
const https = require('https');
const messaging = functions.app.admin.messaging();

admin.initializeApp();

exports.newBooking = functions.https.onCall(async (data, context) => {
    let receiverFCMToken = data.trainerToken;
    let clientName = data.name;
    let sessionDay = data.day;
    let sessionTime = data.time;

    title = 'New Booking';
    body = clientName + ' has booked a session for ' + sessionDay + ', ' + sessionTime;

    const message = {
        'token': receiverFCMToken,
        'notification': {
            title,
            body
        }
    }
    
    messaging.send(message);
    }
)

exports.cancelBooking = functions.https.onCall(async (data, context) => {
    let receiverFCMToken = data.trainerToken;
    let clientName = data.name;
    let sessionDay = data.day;
    let sessionTime = data.time;

    title = 'Cancelled Booking';
    body = clientName + ' has cancelled their session on ' + sessionDay + ', ' + sessionTime;

    const message = {
        'token': receiverFCMToken,
        'notification': {
            title,
            body
        }
    }
    
    messaging.send(message);
    
})

exports.trainerCancelBooking = functions.https.onCall(async (data, context) => {
    let receiverFCMToken = data.clientToken;
    let sessionDay = data.day;
    let sessionTime = data.time;

    title = 'Session Cancelled';
    body =  'Your session for ' + sessionDay + ' at ' + sessionTime + ' has been cancelled. Please contact your trainer for more details.';

    const message = {
        'token': receiverFCMToken,
        'notification': {
            title,
            body
        }
    }
    
    messaging.send(message);
    
})


exports.createClient = functions.https.onCall(async (data, context) => {
    let authResult = await admin.auth().createUser(
        {
            email: data.email,
            password: data.password,
        }
    );

    return authResult.uid;
})

exports.initializeTransaction = functions.https.onCall(async (data, context) => {
    let responseReceived = false;
    let responseData = 'fire';

    const params = JSON.stringify({
        "email": data.email,
        "amount": data.amount
    })
    const options = {
        hostname: 'api.paystack.co',
        port: 443,
        path: '/transaction/initialize',
        method: 'POST',
        headers: {
            Authorization: 'Bearer sk_test_2f5ee20581c13fb66ee3e48adb68ad81042c337b',
            'Content-Type': 'application/json'
        }
    }

    const request =  new Promise((resolve, reject) => {

        const req = https.request(options, resp => {
            let data = ''
            resp.on('data', (chunk) => {
                data += chunk

                console.log(data);
            });

            resp.on('end', () => {
                data = JSON.parse(data)



                if (data.status === true)
                    resolve(data.data.access_code + ' ' + data.data.reference)
                else
                    resolve('ERROR')


                responseReceived = true
            })
        }).on('error', error => {
            console.log(error)
            resolve('ERROR')
        })



        req.write(params)
        req.end()
    })

    return await request.then((val) => {
        return val;
    })
    .catch((e) => {
        return 'ERROR'
    })


})

exports.verifyTransaction = functions.https.onCall(async (data, context) => {
    const options = {
        hostname: 'api.paystack.co',
        port: 443,
        path: '/transaction/verify/' + data.reference,
        method: 'GET',
        headers: {
            Authorization: 'Bearer sk_test_2f5ee20581c13fb66ee3e48adb68ad81042c337b'
        }
    }

    const request = new Promise((resolve, reject) => {
        https.request(options, resp => {
            let data = ''
    
            resp.on('data', (chunk) => {
                data += chunk
                console.log(data)
            });
    
            resp.on('end', () => {
                data = JSON.parse(data)
    
                if (data.data.success === 'success')
                    resolve(true)
                else
                    resolve(false)
            })
    
        }).on('error', error => {
            console.log(error)
            resolve(false)
        })
    })



    return await request.then((val) => {
        return true
    })
    .catch((e) => {
        return false
    })
})