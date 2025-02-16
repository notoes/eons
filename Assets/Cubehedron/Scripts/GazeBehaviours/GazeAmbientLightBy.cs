﻿using UnityEngine;
using System.Collections;

public class GazeAmbientLightBy : GazeBehaviour
{
    [SerializeField] private Color ambientColorBy;
    [SerializeField] private float time = 1;

    private ColorLerper colorLerper;
    private Color fromColor;

    void Awake()
    {
        colorLerper = new ColorLerper( gameObject );
    }

    protected override void DoGazeEnter( GazeHit hit )
    {
        fromColor = RenderSettings.ambientLight;
        colorLerper.Lerp( fromColor, fromColor + ambientColorBy, v=>RenderSettings.ambientLight=v, time );
    }

    protected override void DoGazeExit( GazeHit hit )
    {
        var colorDiff = RenderSettings.ambientLight - fromColor;
        colorLerper.Lerp( RenderSettings.ambientLight, fromColor - colorDiff, v=>RenderSettings.ambientLight=v, time );
    }

    protected override void DoGazeStop( GazeHit hit )
    {
        colorLerper.Stop();
    }
}
