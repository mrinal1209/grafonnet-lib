local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local text = grafana.text;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local row = grafana.row;
local singlestat = grafana.singlestat;
local tablePanel = grafana.tablePanel;


dashboard.new(
  'Advanced Data Exploration',
  time_from='now-1h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=2,
  tags=['Percona','Insight'],
  iteration=1554487736833,
  uid="1oz9QMHmk",
  timepicker = timepicker.new(
    hidden = false,
    collapse= false,
    enable= true,
    notice=false,
    now= true,
    status='Stable',
    ),
)
.addAnnotation(
  grafana.annotation.datasource(
    'PMM Annotations',
    '-- Grafana --',
    enable=true,
    hide=false,
    type='tags',
    builtIn=1,
    iconColor='#e0752d',
    limit=100,
    tags = ['pmm_annotation'],
  )
)
.addAnnotation(
  grafana.annotation.datasource(
    'Annotations & Alerts',
    '-- Grafana --',
    enable=true,
    hide=true,
    type='dashboard',
    builtIn=1,
    iconColor='#6ed0e0',
    limit=100,
  )
)
.addLink(
  grafana.link.dashboards(
    'Query Analytics',
    ['QAN'],
    type='link',
    url='/graph/d/7w6Q3PJmz/pmm-query-analytics',
    keepTime=true,
    includeVars=true,
    asDropdown=false,
    icon='dashboard',
  )
)
.addLink(
  grafana.link.dashboards(
    'OS',
    ['OS'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'MySQL',
    ['MySQL'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'MongoDB',
    ['MongoDB'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'PostgreSQL',
    ['PostgreSQL'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'HA',
    ['HA'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'Cloud',
    ['Cloud'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'Insight',
    ['Insight'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'PMM',
    ['PMM'],
    keepTime=true,
    includeVars=true,
  )
)
.addTemplate(
  template.new(
  'metric',
  'Prometheus',
  'metrics(.*)',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  definition='',
  ),
)
.addTemplate(
    template.interval('interval', 'auto,1s,5s,1m,5m,1h,6h,1d', 'auto', label='Interval', auto_count=200, auto_min='1s'),
)
.addTemplate(
  template.new(
  'host',
  'Prometheus',
  'label_values($metric, instance)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='pipe',
  multiFormat='pipe',
  multi=true,
  skipUrlSync=false,
  definition='',
  includeAll=true,
  hide=2,
  ),
)
.addTemplate(
  template.pmmCustom(
    'adhoc',
    'adhoc',
    null,
    datasource='Prometheus',
    label='Ad-hoc',
    skipUrlSync=false,
  )
)
.addPanel(
  singlestat.new(
    'Metric Name',//title
    datasource='Prometheus',
    colorValue=true,
    thresholds='',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "#1f78c1",
      "rgba(50, 172, 45, 0.97)",
     ],
    height='50px',
    transparent=true,
    valueFontSize='50%',
  )
  .addTarget(
    prometheus.target(
      '$metric',
      format='table',
      refId='A',
      legendFormat='$metric',
      step=60,
      hide=false,
    )
  ),
  gridPos = {
    "h": 2,
    "w": 12,
    "x": 0,
    "y": 0,
     },
  style=null,
)//7 singlestat
.addPanel(
  singlestat.new(
    'Metric Resolution',//title
    datasource='Prometheus',
    format='s',
    colorValue=true,
    thresholds='',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "#1f78c1",
      "rgba(50, 172, 45, 0.97)",
     ],
    height='50px',
    transparent=true,
  )
  .addTarget(
    prometheus.target(
      'avg(60/count_over_time($metric{instance=~"$host"}[1m]))',
      format='table',
      refId='A',
      legendFormat='$metric',
      step=60,
    )
    ),
  gridPos = {
    "h": 2,
    "w": 12,
    "x": 12,
    "y": 0,
     },
  style=null,
)//9 singlestat
.addPanel(
  graphPanel.new(
    'View Actual Metric Values (Gauge)',//title
    description='A gauge is a metric that represents a single numerical value that can arbitrarily go up and down.

    Gauges are typically used for measured values like temperatures or current memory usage, but also "counts" that can go up and down, like the number of running goroutines.',
    fill=1,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=1,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    legend_current=true,
    editable=true,
    format='short',
    thresholds=[
      {
          "colorMode": "custom",
          "line": true,
          "lineColor": "rgb(241, 34, 15)",
          "op": "gt",
          "value": 15
      }
     ],
  )
  .addTarget(
      prometheus.target(
        '$metric{instance=~"$host"}',
        refId='B',
        interval='$interval',
        calculatedInterval='10s',
        step=20,
        intervalFactor=1,
        legendFormat='',
      )
   ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 2,
   },
  style=null,
)//6 graph
.addPanel(
  graphPanel.new(
    'View Metric Rate of Change (Counter)',//title
    description='A counter is a cumulative metric that represents a single numerical value that only ever goes up. A counter is typically used to count requests served, tasks completed, errors occurred, etc. Counters should not be used to expose current counts of items whose number can also go down, e.g. the number of currently running goroutines. Use gauges for this use case.',
    fill=1,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=1,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_current=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    format='short',
    value_type='cumulative',
  )
  .addTarget(
      prometheus.target(
        'rate($metric{instance=~"$host"}[$interval])',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='',
      )
   ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 9,
   },
  style=null,
)//4 graph
.addPanel(
  graphPanel.new(
    'Metric Rates',//title
    description='Shows  Number of Samples Per Second Stored for Given Interval in the Time Series',
    fill=1,
    bars=true,
    lines=false,
    linewidth=1,
    decimals=2,
    datasource='Prometheus',
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    legend_current=true,
    editable=true,
    formatY1='ops',
    formatY2='short',
    stack=true,
  )
  .addTarget(
      prometheus.target(
        'count_over_time($metric{instance=~"$host"}[$interval])',
        refId='A',
        interval='$interval',
        intervalFactor=1,
      )
   ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 16,
   },
  style=null,
)//11 graph
.addPanel(
  tablePanel.new(
    title='Metric Data Table',
    datasource='Prometheus',
    fontSize='100%',
    scroll=true,
    showHeader=true,
    sort={
      "col":0,
      "desc":true,
    },
  )
  .addStyle(
    {
        "alias": "Time",
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "pattern": "Time",
        "type": "date"
    }
  )
  .addStyle(
    {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "decimals": 2,
          "pattern": "/.*/",
          "thresholds": [],
          "type": "number",
          "unit": "short"
    }
  )
  .addTarget(
    prometheus.target(
      '$metric{instance=~"$host"}',
      format='table',
      refId='A',
      step=4,
   )
   ),
  gridPos={
   "h": 7,
   "w": 24,
   "x": 0,
   "y": 23,
    },
    style=null,
)//8 table
