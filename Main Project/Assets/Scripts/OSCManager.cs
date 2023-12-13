using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;
using uOSC;

public class OSCManager : MonoBehaviour
{
    // singleton pattern
    public static OSCManager Instance;
    
    private uOscClient _client;

    public List<Transform> boidTransforms = new List<Transform>();

    private float[] _distances;

    private Vector3[] _positions;

    [SerializeField] private Transform camTransform;

    [SerializeField] private Spawner _spawner;
    
    void Awake()
    {
        // create singleton
        if (Instance == null)
        {
            Instance = this;
        }
        else
        {
            Destroy(gameObject);
        }
    }

    private void Start()
    {
        _client = GetComponent<uOscClient>();

        _distances = new float[_spawner.spawnCount];
        _positions = new Vector3[_spawner.spawnCount];
    }

    // Update is called once per frame
    void Update()
    {
        for (int i = 0; i < boidTransforms.Count; i++)
        {
            Vector3 boidPos = boidTransforms[i].position;
            _distances[i] = Vector3.Distance(camTransform.position, boidPos);
            _positions[i] = boidPos;
        }
        
        _client.Send("/boids/data", _distances, _positions);
    }
}
