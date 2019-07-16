local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local text = grafana.text;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local row = grafana.row;

dashboard.new(
  'MySQL Performance Schema',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=3,
  tags=['MySQL','Percona'],
  iteration=1552405861443,
  uid="BLk9wGNmz",
  timepicker = timepicker.new(
      hidden=false,
      collapse=false,
      enable=true,
      notice=false,
      now=true,
      status='Stable',
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
  multiFormat='regex values',
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
.addPanel(
  graphPanel.new(
    'Performance Schema File IO (Events)',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    nullPointMode="null as zero",
    legend_values=true,
    legend_min=false,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideZero=true,
    legend_hideEmpty=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    value_type='cumulative',
    decimalsY1=2,
    logBase1Y=2,
    minY2=0,
  )
  .addTarget(
      prometheus.target(
        'topk(10, rate(mysql_perf_schema_file_events_total{service_name="$service"}[$interval])>0) or topk(10, irate(mysql_perf_schema_file_events_total{service_name="$service"}[5m])>0)',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{event_name}} {{mode}}',
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 0,
  },
  style=null,
)//47 graph
.addPanel(
  graphPanel.new(
    'Performance Schema File IO (Load)',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    nullPointMode="null as zero",
    legend_values=true,
    legend_min=false,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideZero=true,
    legend_hideEmpty=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    stack=true,
    minY2=0,
  )
  .addTarget(
      prometheus.target(
        'topk(10, rate(mysql_perf_schema_file_events_seconds_total{service_name="$service"}[$interval])>0) or topk(10, irate(mysql_perf_schema_file_events_seconds_total{service_name="$service"}[5m])>0)',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{event_name}} {{mode}}',
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 7,
  },
  style=null,
)//48 graph
.addPanel(
  graphPanel.new(
    'Performance Schema File IO (Bytes)',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    nullPointMode="null as zero",
    legend_values=true,
    legend_min=false,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideZero=true,
    legend_hideEmpty=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    value_type='cumulative',
    formatY1='Bps',
    logBase1Y=2,
    min=0,
  )
  .addTarget(
      prometheus.target(
        'topk(10, rate(mysql_perf_schema_file_events_bytes_total{service_name="$service"}[$interval])>0) or
        topk(10, irate(mysql_perf_schema_file_events_bytes_total{service_name="$service"}[5m])>0)',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{event_name}} {{mode}}',
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 14,
  },
  style=null,
)//49 graph
.addPanel(
  graphPanel.new(
    'Performance Schema Waits (Events)',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    nullPointMode="null as zero",
    legend_values=true,
    legend_min=false,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideZero=true,
    legend_hideEmpty=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    value_type='cumulative',
    stack=true,
    min=0,
  )
  .addTarget(
      prometheus.target(
        'topk(5, rate(mysql_perf_schema_events_waits_total{service_name="$service"}[$interval])>0) or topk(5, irate(mysql_perf_schema_events_waits_total{service_name="$service"}[5m])>0)',
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
    "y": 21,
  },
  style=null,
)//51 graph
.addPanel(
  graphPanel.new(
    'Performance Schema Waits (Load)',//title
    fill=1,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    nullPointMode="null as zero",
    legend_values=true,
    legend_min=false,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideZero=true,
    legend_hideEmpty=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    stack=true,
    steppedLine=true,
    minY2=0,
    logBase1Y=2,
  )
  .addTarget(
      prometheus.target(
        'topk(5, rate(mysql_perf_schema_events_waits_seconds_total{service_name="$service",event_name!="idle",event_name!="wait/io/table/sql/handler"}[$interval])>0) or topk(5, irate(mysql_perf_schema_events_waits_seconds_total{service_name="$service",event_name!="idle",event_name!="wait/io/table/sql/handler"}[5m])>0)',
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
    "y": 28,
  },
  style=null,
)//52 graph
.addPanel(
  graphPanel.new(
    'Index Access Operations (Load)',//title
    fill=1,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    nullPointMode="null as zero",
    legend_values=true,
    legend_min=false,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideZero=true,
    legend_hideEmpty=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    stack=true,
    steppedLine=true,
    min=0,
  )
  .addTarget(
      prometheus.target(
        'topk(5, rate(mysql_perf_schema_index_io_waits_seconds_total{service_name="$service"}[$interval])>0) or topk(5, irate(mysql_perf_schema_index_io_waits_seconds_total{service_name="$service"}[5m])>0)',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{operation}} {{index}} {{schema}}.{{name}}',
      )
  ),
  gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 35,
  },
  style=null,
)//77 graph
.addPanel(
  graphPanel.new(
    'Table Access Operations (Load)',//title
    fill=1,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    nullPointMode="null as zero",
    legend_values=true,
    legend_min=false,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideZero=true,
    legend_hideEmpty=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    stack=true,
    steppedLine=true,
    min=0,
  )
  .addTarget(
      prometheus.target(
        'topk(5, rate(mysql_perf_schema_table_io_waits_seconds_total{service_name="$service"}[$interval])>0) or topk(5, irate(mysql_perf_schema_table_io_waits_seconds_total{service_name="$service"}[5m])>0)',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{operation}} {{schema}}.{{name}}',
      )
  ),
  gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 42,
  },
  style=null,
)//78 graph
.addPanel(
  graphPanel.new(
    'Performance Schema SQL & External Locks (Events)',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    nullPointMode="null as zero",
    legend_values=true,
    legend_min=false,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_show=true,
    editable=true,
    stack=true,
    minY1='0',
  )
  .addTarget(
      prometheus.target(
        'topk(10, rate(mysql_perf_schema_sql_lock_waits_total{service_name="$service"}[$interval])) or topk(10, irate(mysql_perf_schema_sql_lock_waits_total{service_name="$service"}[5m]))',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='SQL Lock Waits {{ schema }}.{{ operation }}',
      )
  )
  .addTarget(
      prometheus.target(
        'topk(10, rate(mysql_perf_schema_external_lock_waits_total{service_name="$service"}[$interval])>0) or topk(10, irate(mysql_perf_schema_external_lock_waits_total{service_name="$service"}[5m])>0)',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='External Lock Waits {{ schema }}.{{ operation }}',
      )
  ),
  gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 49,
  },
  style=null,
)//79 graph
.addPanel(
  graphPanel.new(
    'Performance Schema SQL and External Locks (Seconds)',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    nullPointMode="null as zero",
    legend_values=true,
    legend_min=false,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_show=true,
    editable=true,
    formatY1='s',
  )
  .addTarget(
      prometheus.target(
        'topk(10, rate(mysql_perf_schema_external_lock_waits_seconds_total{service_name="$service"}[$interval])>0) or topk(10, irate(mysql_perf_schema_external_lock_waits_seconds_total{service_name="$service"}[5m])>0)',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='External Locks Waits {{ schema }}.{{ name }}.{{ operation }}',
      )
  )
  .addTarget(
      prometheus.target(
        'topk(10, rate(mysql_perf_schema_sql_lock_waits_seconds_total{service_name="$service"}[$interval])>0) or topk(10, irate(mysql_perf_schema_sql_lock_waits_seconds_total{service_name="$service"}[5m])>0)',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='SQL Locks Waits {{ schema }}.{{ name }}.{{ operation }}',
      )
  ),
  gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 56,
  },
  style=null,
)//80 graph
