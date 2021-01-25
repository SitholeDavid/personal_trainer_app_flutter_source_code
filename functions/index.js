const functions = require('firebase-functions');
const admin = require('firebase-admin');
const https = require('https');

admin.initializeApp();

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