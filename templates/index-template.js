'use strict';

exports.handler = async (event, context) => {
    console.log("Event: ", JSON.stringify(event));
    console.log("Context: ", JSON.stringify(context));

    return {
        statusCode: 200,
        body: JSON.stringify({
            applicationName: '{project_name}',
            applicationDescription: '{description}'
        })
    };
};
