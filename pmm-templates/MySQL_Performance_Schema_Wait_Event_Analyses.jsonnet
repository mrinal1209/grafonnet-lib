local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local text = grafana.text;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;


dashboard.new(
  'MySQL Performance Schema Wait Event Analyses',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=3,
  tags=['MySQL','Percona'],
  iteration=1552406186667,
  uid="fl8HVgcmk",
  timepicker = timepicker.new(
    hidden = false,
    now= true,
    )
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
    tags = [  "pmm_annotation",
              "$host",
              "$service"],
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
    template.interval('interval', 'auto,1s,5s,1m,5m,1h,6h,1d', 'auto', label='Interval', auto_count=200, auto_min='1s'),
)
.addTemplate(
  template.new(
  'host',
  'Prometheus',
  'label_values(mysql_global_variables_performance_schema, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='glob',
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_global_variables_performance_schema, node_name)',
  includeAll=false,
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(mysql_global_variables_performance_schema{node_name=~"$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_global_variables_performance_schema{node_name=~"$host"}, service_name)',
  includeAll=false,
  ),
)
.addTemplate(
  template.new(
  'event',
  'Prometheus',
  'label_values(mysql_perf_schema_events_waits_seconds_total{service_name="$service"}, event_name)',
  label='Event',
  refresh='load',
  sort=1,
  multi=true,
  skipUrlSync=false,
  includeAll=false,
  ),
)
.addPanel(
  text.new(
    content='<h1><i><font color=#5991A7><b><center>Data for </font><font color=#e68a00>$host</font> <font color=#5991A7> with</font> </font><font color=#e68a00>$interval</font> <font color=#5991A7>resolution</center></b></font></i></h1>',
    mode='html',
  ),
  gridPos={
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 0,
      },
  style=null,
)//24 text
.addPanel(
  graphPanel.new(
    'Count - Performance Schema Waits',//title
    fill=1,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    lines=false,
    points=true,
    pointradius=1,
    paceLength=10,
    nullPointMode="null as zero",
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideEmpty=true,
    legend_hideZero=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='ops',
    min=0,
    steppedLine=true,
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_perf_schema_events_waits_total{service_name="$service",event_name=~"$event"}[$interval]) or irate(mysql_perf_schema_events_waits_total{service_name="$service",service_name="$service",event_name=~"$event"}[5m])',
        refId='A',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{event_name}}',
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 2
  },
  style=null,
)//27 graph
.addPanel(
  graphPanel.new(
    'Load - Performance Schema Waits',//title
    fill=1,
    linewidth=2,
    decimals=2,
    lines=false,
    points=true,
    datasource='Prometheus',
    pointradius=1,
    paceLength=10,
    nullPointMode="null as zero",
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideEmpty=true,
    legend_hideZero=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min=0,
    steppedLine=true,
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_perf_schema_events_waits_seconds_total{service_name="$service",event_name=~"$event"}[$interval]) or irate(mysql_perf_schema_events_waits_seconds_total{service_name="$service",service_name="$service",event_name=~"$event"}[5m])',
        refId='A',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{event_name}}',
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 9,
  },
  style=null,
)//26 graph
.addPanel(
  graphPanel.new(
    'Avg Wait Time - Performance Schema Waits',//title
    fill=1,
    linewidth=2,
    decimals=2,
    lines=false,
    points=true,
    datasource='Prometheus',
    pointradius=1,
    paceLength=10,
    nullPointMode="null as zero",
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideEmpty=true,
    legend_hideZero=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min=0,
    formatY1='s',
    steppedLine=true,
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_perf_schema_events_waits_seconds_total{service_name="$service",event_name=~"$event"}[$interval])/rate(mysql_perf_schema_events_waits_total{service_name="$service",event_name=~"$event"}[$interval]) or irate(mysql_perf_schema_events_waits_seconds_total{service_name="$service",service_name="$service",event_name=~"$event"}[5m])/irate(mysql_perf_schema_events_waits_total{service_name="$service",service_name="$service",event_name=~"$event"}[5m])',
        refId='A',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{event_name}}',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_perf_schema_events_waits_total{service_name="$service",event_name=~"$event"}[$interval]) or irate(mysql_perf_schema_events_waits_total{service_name="$service",service_name="$service",event_name=~"$event"}[5m])',
        refId='B',
        intervalFactor=1,
        legendFormat='',
        hide=true,
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 16,
  },
  style=null,
)//28 graph
