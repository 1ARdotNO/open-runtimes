import requests
import os

def main(context):
    action = context.req.headers.get('X-Action', None)

    if action == 'plaintextResponse':
        return context.res.send('Hello World 👋')
    elif action == 'jsonResponse':
        return context.res.json({ 'json': true, 'message': 'Developers are awesome.' })
    elif action == 'redirectResponse':
        return context.res.redirect('https://github.com/')
    elif action == 'emptyResponse':
        return context.res.empty()
    elif action == 'noResponse':
        context.res.send('This should be ignored, as it is not returned.')
    elif action == 'doubleResponse':
        context.res.send('This should be ignored.')
        return context.res.send('This should be returned.')
    elif action == 'headersResponse':
        return context.res.send('OK', 200, {
            'first-header': 'first-value',
            'second-header': context.req.headers.get('x-open-runtimes-custom-in-header', 'missing'),
            'x-open-runtimes-custom-out-header': 'third-value'
        })
    elif action == 'statusResponse':
        return context.res.send('FAIL', 404)
    elif action == 'requestMethod':
        return context.res.send(context.req.method)
    elif action == 'requestUrl':
        return context.res.send(context.req.url)
    elif action == 'requestHeaders':
        return context.res.json(context.req.headers)
    elif action == 'requestBodyPlaintext':
        return context.res.send(context.req.body)
    elif action == 'requestBodyJson':
        return context.res.json({
            'key1': context.req.body.get('key1', 'Missing key'),
            'key2': context.req.body.get('key2', 'Missing key'),
            'raw': context.req.rawBody
        })
    elif action == 'envVars':
        return context.res.json({
            'var': os.environ.get('CUSTOM_ENV_VAR', None),
            'emptyVar': os.environ.get('NOT_DEFINED_VAR', None)
        })
    elif action == 'logs':
        print('Native log')
        context.log('Debug log')
        context.error('Error log')

        context.log(42)
        context.log(4.2)
        context.log(True)

        return context.res.send()
    else:
        raise Exception('Unkonwn action')