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
  'MySQL User Statistics',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=3,
  tags=['MySQL','Percona'],
  iteration=1552407413620,
  uid="EEkrQGNmk",
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
    tags = ["pmm_annotation",
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
  'label_values(mysql_info_schema_user_statistics_bytes_sent_total, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='regex values',
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_info_schema_user_statistics_bytes_sent_total, node_name)',
  includeAll=false,
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(mysql_info_schema_user_statistics_bytes_sent_total{node_name=~"$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_info_schema_user_statistics_bytes_sent_total{node_name=~"$host"}, service_name)',
  includeAll=false,
  ),
)
.addPanel(
  graphPanel.new(
    'Top Users by Connections Created',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=false,
    legend_min=false,
    legend_max=false,
    legend_avg=false,
    legend_alignAsTable=false,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_show=true,
    editable=true,
    format='short',
  )
  .resetYaxes()
  .addYaxis(
    label='Connections/sec',
    min=0,
  )
  .addYaxis(
    min=0,
  )
  .addTarget(
      prometheus.target(
        'topk(5, (rate(mysql_info_schema_user_statistics_total_ssl_connections_total{service_name="$service"}[$interval]) + rate(mysql_info_schema_user_statistics_total_connections{service_name="$service"}[$interval]))>0) or topk(5, (irate(mysql_info_schema_user_statistics_total_ssl_connections_total{service_name="$service"}[5m]) + irate(mysql_info_schema_user_statistics_total_connections{service_name="$service"}[5m]))>0)',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ user }}',
      )
  ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 0,
  },
  style=null,
)//25 graph
.addPanel(
  graphPanel.new(
    'Top Users by Traffic',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=false,
    legend_min=false,
    legend_max=false,
    legend_avg=false,
    legend_alignAsTable=false,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_show=true,
    editable=true,
    formatY1='Bps',
    formatY2='short',
    min=0,
  )
  .addTarget(
      prometheus.target(
        'topk(5, (rate(mysql_info_schema_user_statistics_bytes_sent_total{service_name="$service"}[$interval]) + rate(mysql_info_schema_user_statistics_bytes_received_total{service_name="$service"}[$interval]))>0) or
        topk(5, (irate(mysql_info_schema_user_statistics_bytes_sent_total{service_name="$service"}[5m]) + irate(mysql_info_schema_user_statistics_bytes_received_total{service_name="$service"}[5m]))>0)',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ user }}',
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 0,
  },
  style=null,
)//39 graph
.addPanel(
  graphPanel.new(
    'Top Users by Rows Fetched/Read',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=false,
    legend_min=false,
    legend_max=false,
    legend_avg=false,
    legend_alignAsTable=false,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_show=true,
    editable=true,
    format='short',
  )
  .resetYaxes()
  .addYaxis(
    label='Rows/sec',
    min=0,
  )
  .addYaxis(
    min=0,
  )
  .addTarget(
      prometheus.target(
        'topk(5, rate(mysql_info_schema_user_statistics_rows_fetched_total{service_name="$service"}[$interval])>0) or topk(5, irate(mysql_info_schema_user_statistics_rows_fetched_total{service_name="$service"}[5m])>0) or topk(5, rate(mysql_info_schema_user_statistics_rows_read_total{service_name="$service"}[$interval])>0) or topk(5, irate(mysql_info_schema_user_statistics_rows_read_total{service_name="$service"}[5m])>0)',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ user }}',
      )
  ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 7,
  },
  style=null,
)//37 graph
.addPanel(
  graphPanel.new(
    'Top Users by Rows Updated',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=false,
    legend_min=false,
    legend_max=false,
    legend_avg=false,
    legend_alignAsTable=false,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_show=true,
    editable=true,
    format='short',
  )
  .resetYaxes()
  .addYaxis(
    label='Rows/sec',
    min=0,
  )
  .addYaxis(
    min=0,
    show=false,
  )
  .addTarget(
      prometheus.target(
        'topk(5, rate(mysql_info_schema_user_statistics_rows_updated_total{service_name="$service"}[$interval])>0) or
        topk(5, irate(mysql_info_schema_user_statistics_rows_updated_total{service_name="$service"}[5m])>0)',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ user }}',
      )
  ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 7,
  },
  style=null,
)//38 graph
.addPanel(
  graphPanel.new(
    'Top Users by Busy Load',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=false,
    legend_min=false,
    legend_max=false,
    legend_avg=false,
    legend_alignAsTable=false,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_show=true,
    editable=true,
    format='short',
    min=0,
  )
  .addTarget(
      prometheus.target(
        'topk(5, rate(mysql_info_schema_user_statistics_busy_seconds_total{service_name="$service"}[$interval])>0) or topk(5, irate(mysql_info_schema_user_statistics_busy_seconds_total{service_name="$service"}[5m])>0)',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ user }}',
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 14,
  },
  style=null,
)//40 graph
.addPanel(
  graphPanel.new(
    'Top Users by CPU Load',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=false,
    legend_min=false,
    legend_max=false,
    legend_avg=false,
    legend_alignAsTable=false,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_show=true,
    editable=true,
    format='short',
    min=0,
  )
  .addTarget(
      prometheus.target(
        'topk(5, rate(mysql_info_schema_user_statistics_cpu_time_seconds_total{service_name="$service"}[$interval])>0) or
        topk(5, irate(mysql_info_schema_user_statistics_cpu_time_seconds_total{service_name="$service"}[5m])>0)',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ user }}',
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 14,
  },
  style=null,
)//41 graph
.addPanel(
  text.new(
    content="These graphs are available only for [Percona Server](https://www.percona.com/doc/percona-server/5.6/diagnostics/user_stats.html) and [MariaDB](https://mariadb.com/kb/en/mariadb/user-statistics/) and require `userstat` variable turned on.",
    height='50px',
    mode='markdown',
    transparent=true,
    editable=true,
    datasource='Prometheus',

  ),
  gridPos={
    "h": 3,
    "w": 24,
    "x": 0,
    "y": 21,
      },
  style=null,
)//36 text
