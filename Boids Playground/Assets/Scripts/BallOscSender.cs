using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using uOSC;

public class BallOscSender : MonoBehaviour
{
    uOscClient client;

    void Start()
    {
        // This gets the uOscClient component attached to the same GameObject as this script.
        client = GetComponent<uOscClient>();
    }

    void Update()
    {
        // Let's send the ball's position continuously.
        Vector3 position = transform.position;
        client.Send("/ball/position", position.x, position.y, position.z);

        // Log the position to the Console window every frame.
        Debug.Log("Ball Position: " + position);

    }

    // This method will be called when the ball bounces.
    public void SendBounceMessage()
    {
        // We send a message with the address "/ball/bounce" and no additional arguments.
        client.Send("/ball/bounce");

        Debug.Log("Ball Bounced!");

    }

    void OnCollisionEnter(Collision collision)
    {
        // Call the method that sends the OSC message when the ball collides with something.
        SendBounceMessage();
    }
}

