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
  'MySQL Query Response Time',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=3,
  tags=['MySQL','Percona'],
  iteration=1552406398482,
  uid="fsZR9omik",
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
  'label_values(mysql_info_schema_query_response_time_seconds_sum, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='glob',
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_info_schema_query_response_time_seconds_sum, node_name)',
  includeAll=false,
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(mysql_info_schema_query_response_time_seconds_sum{node_name=~"$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_info_schema_query_response_time_seconds_sum{node_name=~"$host"}, service_name)',
  includeAll=false,
  ),
)
.addPanel(
    row.new(
      title='Average Query Response Time',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0,
    },
    style=null,
)//11 row
.addPanel(
  graphPanel.new(
    'Average Query Response Time',//title
    description="The Average Query Response Time graph shows information collected using the Response Time Distribution plugin sourced from [table INFORMATION_SCHEMA. QUERY_RESPONSE_TIME](https://www.percona.com/doc/percona-server/5.7/diagnostics/response_time_distribution.html#QUERY_RESPONSE_TIME). It computes this value across all queries by taking the sum of seconds divided by the count of queries.",
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_show=true,
    editable=true,
    formatY1='ms',
    min=0,
    value_type='cumulative',
    links=[
        {
          "targetBlank": true,
          "title": "More information about Query Response Time plugin in Percona Server",
          "type": "absolute",
          "url": "https://www.percona.com/doc/percona-server/5.7/diagnostics/response_time_distribution.html#QUERY_RESPONSE_TIME"
        }
      ],
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_info_schema_query_response_time_seconds_sum{service_name="$service"}[$interval]) / rate(mysql_info_schema_query_response_time_seconds_count{service_name="$service"}[$interval]) * 1000 or irate(mysql_info_schema_query_response_time_seconds_sum{service_name="$service"}[5m]) / irate(mysql_info_schema_query_response_time_seconds_count{service_name="$service"}[5m]) * 1000',
        refId='B',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Time',
        calculatedInterval='2m',
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 1,
  },
  style=null,
)//6 graph
.addPanel(
    row.new(
      title='Query Response Time Distribution',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 8,
    },
    style=null,
)//12 row
.addPanel(
  graphPanel.new(
    'Query Response Time Distribution',//title
    description="Query response time counts (operations) are grouped into three buckets:

    * 100ms - 1s

    * 1s - 10s

    * &gt; 10s",
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_show=true,
    editable=true,
    format='ops',
    min=0,
    links=[
        {
          "targetBlank": true,
          "title": "More information about Query Response Time plugin in Percona Server",
          "type": "absolute",
          "url": "https://www.percona.com/doc/percona-server/5.7/diagnostics/response_time_distribution.html#QUERY_RESPONSE_TIME"
        }
      ],
  )
  .addSeriesOverride(
      {
          "alias": "Queries >10s",
          "color": "#E24D42"
        }
  )
  .addSeriesOverride(
      {
          "alias": "Queries 1s - 10s",
          "color": "#EF843C"
        }
  )
  .addSeriesOverride(
      {
          "alias": "Queries 100ms - 1s",
          "color": "#EAB839"
        }
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_info_schema_query_response_time_seconds_bucket{service_name="$service",le="1"}[$interval]) - on (instance) rate(mysql_info_schema_query_response_time_seconds_bucket{service_name="$service",le="0.1"}[$interval])) or (irate(mysql_info_schema_query_response_time_seconds_bucket{service_name="$service",le="1"}[5m]) - on (instance) irate(mysql_info_schema_query_response_time_seconds_bucket{service_name="$service",le="0.1"}[5m]))',
        refId='A',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Queries 100ms - 1s',
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_info_schema_query_response_time_seconds_bucket{service_name="$service",le="10"}[$interval])  - on (instance) rate(mysql_info_schema_query_response_time_seconds_bucket{service_name="$service",le="1"}[$interval])) or (irate(mysql_info_schema_query_response_time_seconds_bucket{service_name="$service",le="10"}[5m])  - on (instance) irate(mysql_info_schema_query_response_time_seconds_bucket{service_name="$service",le="1"}[5m]))',
        refId='B',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Queries 1s - 10s',
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_info_schema_query_response_time_seconds_bucket{service_name="$service",le="100000"}[$interval])  - on (instance) rate(mysql_info_schema_query_response_time_seconds_bucket{service_name="$service",le="10"}[$interval])) or (irate(mysql_info_schema_query_response_time_seconds_bucket{service_name="$service",le="100000"}[5m])  - on (instance) irate(mysql_info_schema_query_response_time_seconds_bucket{service_name="$service",le="10"}[5m]))',
        refId='C',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Queries >10s',
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 9,
  },
  style=null,
)//7 graph
.addPanel(
  text.new(
    content="These graphs are available only for [Percona Server](https://www.percona.com/doc/percona-server/5.6/diagnostics/response_time_distribution.html) and [MariaDB](https://mariadb.com/kb/en/mariadb/query_response_time-plugin/). It requires query response time plugin installed and `query_response_time_stats ` variable turned on.

Read/write split below is available only for Percona Server 5.6/5.7.",
    datasource="Prometheus",
    height='50px',
    mode='markdown',
    transparent=true,
  ),
  gridPos={
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 16,
      },
  style=null,
)//5 text
.addPanel(
    row.new(
      title='Read/Write Split',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 19,
    },
    style=null,
)//13 row
.addPanel(
  graphPanel.new(
    'Average Query Response Time',//title
    description="Available only in [Percona Server for MySQL](https://www.percona.com/doc/percona-server/5.7/diagnostics/response_time_distribution.html#logging-the-queries-in-separate-read-and-write-tables), provides  visibility of the split of [READ](https://www.percona.com/doc/percona-server/5.7/diagnostics/response_time_distribution.html#QUERY_RESPONSE_TIME_READ) vs [WRITE](https://www.percona.com/doc/percona-server/5.7/diagnostics/response_time_distribution.html#QUERY_RESPONSE_TIME_WRITE) query response time.",
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_show=true,
    editable=true,
    formatY1='ms',
    value_type='cumulative',
    min=0,
    links=[
          {
            "targetBlank": true,
            "title": "More information about Query Response Time plugin in Percona Server",
            "type": "absolute",
            "url": "https://www.percona.com/doc/percona-server/5.7/diagnostics/response_time_distribution.html#logging-the-queries-in-separate-read-and-write-tables"
          }
        ],
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_info_schema_read_query_response_time_seconds_sum{service_name="$service"}[$interval]) / rate(mysql_info_schema_read_query_response_time_seconds_count{service_name="$service"}[$interval]) * 1000 or irate(mysql_info_schema_read_query_response_time_seconds_sum{service_name="$service"}[5m]) / irate(mysql_info_schema_read_query_response_time_seconds_count{service_name="$service"}[5m]) * 1000',
        refId='B',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Read Query Time',
        calculatedInterval='2m',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_info_schema_write_query_response_time_seconds_sum{service_name="$service"}[$interval]) / rate(mysql_info_schema_write_query_response_time_seconds_count{service_name="$service"}[$interval]) * 1000 or irate(mysql_info_schema_write_query_response_time_seconds_sum{service_name="$service"}[5m]) / irate(mysql_info_schema_write_query_response_time_seconds_count{service_name="$service"}[5m]) * 1000',
        refId='A',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Write Query Time',
        calculatedInterval='2m',
      )
  ),
  gridPos={
      "h": 7,
       "w": 24,
       "x": 0,
       "y": 20,
  },
  style=null,
)//8 graph
.addPanel(
    row.new(
      title='Query Response Time Distribution',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 27,
    },
    style=null,
)//14 row
.addPanel(
  graphPanel.new(
    'Read Query Response Time Distribution',//title
    description="Available only in Percona Server for MySQL, illustrates READ query response time counts (operations) grouped into three buckets:

    * 100ms - 1s

    * 1s - 10s

    * &gt; 10s",
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    format='ops',
    min=0,
    links=[
        {
          "targetBlank": true,
          "title": "More information about Query Response Time plugin in Percona Server",
          "type": "absolute",
          "url": "https://www.percona.com/doc/percona-server/5.7/diagnostics/response_time_distribution.html#QUERY_RESPONSE_TIME_READ"
        }
      ],
  )
  .addSeriesOverride(
      {
          "alias": "Queries >10s",
          "color": "#E24D42"
        }
  )
  .addSeriesOverride(
      {
          "alias": "Queries 1s - 10s",
          "color": "#EF843C"
        }
  )
  .addSeriesOverride(
      {
          "alias": "Queries 100ms - 1s",
          "color": "#EAB839"
        }
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_info_schema_read_query_response_time_seconds_bucket{service_name="$service",le="1"}[$interval]) - on (instance) rate(mysql_info_schema_read_query_response_time_seconds_bucket{service_name="$service",le="0.1"}[$interval])) or (irate(mysql_info_schema_read_query_response_time_seconds_bucket{service_name="$service",le="1"}[5m]) - on (instance) irate(mysql_info_schema_read_query_response_time_seconds_bucket{service_name="$service",le="0.1"}[5m]))',
        refId='A',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Queries 100ms - 1s',
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_info_schema_read_query_response_time_seconds_bucket{service_name="$service",le="10"}[$interval])  - on (instance) rate(mysql_info_schema_read_query_response_time_seconds_bucket{service_name="$service",le="1"}[$interval])) or (irate(mysql_info_schema_read_query_response_time_seconds_bucket{service_name="$service",le="10"}[5m])  - on (instance) irate(mysql_info_schema_read_query_response_time_seconds_bucket{service_name="$service",le="1"}[5m]))',
        refId='B',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Queries 1s - 10s',
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_info_schema_read_query_response_time_seconds_bucket{service_name="$service",le="100000"}[$interval])  - on (instance) rate(mysql_info_schema_read_query_response_time_seconds_bucket{service_name="$service",le="10"}[$interval])) or (irate(mysql_info_schema_read_query_response_time_seconds_bucket{service_name="$service",le="100000"}[5m])  - on (instance) irate(mysql_info_schema_read_query_response_time_seconds_bucket{service_name="$service",le="10"}[5m]))',
        refId='C',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Queries >10s',
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 28,
  },
  style=null,
)//9 graph
.addPanel(
  graphPanel.new(
    'Write Query Response Time Distribution',//title
    description="Available only in Percona Server for MySQL, illustrates WRITE query response time counts (operations) grouped into three buckets:

    * 100ms - 1s

    * 1s - 10s

    * &gt; 10s",
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    format='ops',
    min=0,
    links=[
        {
          "targetBlank": true,
          "title": "More information about Query Response Time plugin in Percona Server",
          "type": "absolute",
          "url": "https://www.percona.com/doc/percona-server/5.7/diagnostics/response_time_distribution.html#QUERY_RESPONSE_TIME_READ"
        }
      ],
  )
  .addSeriesOverride(
      {
          "alias": "Queries >10s",
          "color": "#E24D42"
        }
  )
  .addSeriesOverride(
      {
          "alias": "Queries 1s - 10s",
          "color": "#EF843C"
        }
  )
  .addSeriesOverride(
      {
          "alias": "Queries 100ms - 1s",
          "color": "#EAB839"
        }
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_info_schema_write_query_response_time_seconds_bucket{service_name="$service",le="1"}[$interval]) - on (instance) rate(mysql_info_schema_write_query_response_time_seconds_bucket{service_name="$service",le="0.1"}[$interval])) or (irate(mysql_info_schema_write_query_response_time_seconds_bucket{service_name="$service",le="1"}[5m]) - on (instance) irate(mysql_info_schema_write_query_response_time_seconds_bucket{service_name="$service",le="0.1"}[5m]))',
        refId='A',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Queries 100ms - 1s',
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_info_schema_write_query_response_time_seconds_bucket{service_name="$service",le="10"}[$interval])  - on (instance) rate(mysql_info_schema_write_query_response_time_seconds_bucket{service_name="$service",le="1"}[$interval])) or (irate(mysql_info_schema_write_query_response_time_seconds_bucket{service_name="$service",le="10"}[5m])  - on (instance) irate(mysql_info_schema_write_query_response_time_seconds_bucket{service_name="$service",le="1"}[5m]))',
        refId='B',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Queries 1s - 10s',
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_info_schema_write_query_response_time_seconds_bucket{service_name="$service",le="100000"}[$interval])  - on (instance) rate(mysql_info_schema_write_query_response_time_seconds_bucket{service_name="$service",le="10"}[$interval])) or (irate(mysql_info_schema_write_query_response_time_seconds_bucket{service_name="$service",le="100000"}[5m])  - on (instance) irate(mysql_info_schema_write_query_response_time_seconds_bucket{service_name="$service",le="10"}[5m]))',
        refId='C',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Queries >10s',
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 28,
  },
  style=null,
)//10 graph
