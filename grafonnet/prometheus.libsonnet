{
  target(
    expr,
    format='time_series',
    intervalFactor=2,
    legendFormat=null,
    datasource=null,
    interval=null,
    instant=null,
    refId=null,
    calculatedInterval=null,
    step=null,
    hide = null,
    metric=null,
  ):: {
    [if datasource != null then 'datasource']: datasource,
    expr: expr,
    format: format,
    intervalFactor: intervalFactor,
    refId:refId,
    [if hide != null then 'hide']: hide,
    [if interval != null then 'interval']: interval,
    [if instant != null then 'instant']: instant,
    [if legendFormat != null then 'legendFormat']: legendFormat,
    [if calculatedInterval != null then 'calculatedInterval']: calculatedInterval,
    [if step != null then 'step']: step,
    [if metric != null then 'metric']: metric,
  },
}
