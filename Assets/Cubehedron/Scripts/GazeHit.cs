﻿using UnityEngine;
using System.Collections;


/**
 * A hit from the gaze.
 */
public struct GazeHit {
    // The GazeInput this hit came from.
    public GazeInput gazeInput;

    // The Raycast from the gaze that caused this hit.
    public RaycastHit hit;

    public override string ToString()
    {
        var n = hit.transform==null ? "Nothing" : hit.transform.name;
        return string.Format( "GazeHit - Gaze Input:{0}, Hit Object:{1}", gazeInput, n );
    }
}
