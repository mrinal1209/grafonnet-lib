local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local template = grafana.template;
local prometheus = grafana.prometheus;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local row = grafana.row;
local singlestat = grafana.singlestat;
local tablePanel = grafana.tablePanel;


dashboard.new(
  'ProxySQL Overview',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=16,
  style='dark',
  uid='fwWR9oiiz',
  version=1,
  timepicker = timepicker.new(
    hidden = false,
    collapse= false,
    enable= true,
    notice=false,
    now= true,
    status='Stable',
  ),
  iteration=1548157989684,
  tags=['Percona','HA'],
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
    url='/graph/dashboard/db/_pmm-query-analytics',
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
  'proxysql',
  'Prometheus',
  'label_values(proxysql_mysql_status_active_transactions, node_name)',
  label='ProxySQL Instance',
  refresh='load',
  sort=1,
  refresh_on_load=false,
  allFormat='glob',
  multiFormat='regex values'
  ),
)
.addTemplate(
  template.new(
  'hostgroup',
  'Prometheus',
  'label_values(proxysql_connection_pool_status{node_name="$proxysql"}, hostgroup)',
  label='Hostgroup',
  refresh='load',
  sort=3,
  refresh_on_load=false,
  allFormat='glob',
  multiFormat='regex values',
  multi=true,
  includeAll=false,
  ),
)
.addPanel(
    row.new(
      title='ProxySQL Instance Stats',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 0,
    },
    style=null,
)//67 row
.addPanel(
  graphPanel.new(
  'Hostgroup Size',//title
  fill=0,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=false,
  legend_alignAsTable=true,
  legend_rightSide=true,
  legend_show=false,
  editable=true,
  format = 'short',
  logBase1Y=2,
  logBase2Y=1,
  max = 100,
  min = 0,
  value_type='cumulative',
  transparent=true,
  steppedLine=true,
  show_xaxis=false,
  )
  .addSeriesOverride(
      {
        "alias": "Size",
        "color": "#5195CE"
      }
  )
  .addTarget(
    prometheus.target(
    'scalar(count(proxysql_connection_pool_status{node_name="$proxysql", hostgroup="$hostgroup"}))',
    intervalFactor = 1,
    legendFormat='Size',
    refId='C',
    interval='$interval',
    calculatedInterval='2m',
    step=300,
    )
  ),gridPos={
      "h": 4,
      "w": 24,
      "x": 0,
      "y": 1,
  },style=null,
)//42 graph
.addPanel(
    row.new(
      title='Connections',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 5,
    },
    style=null,
)//68 row
.addPanel(
  graphPanel.new(
  'Client Connections (All Host Groups)',//title
  fill=2,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  format = 'short',
  value_type='cumulative',
  stack=true,
  )
  .addTarget(
    prometheus.target(
    'proxysql_mysql_status_client_connections_connected{node_name="$proxysql"}',
    intervalFactor = 1,
    legendFormat='Connections',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=60,
    )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 6,
  },style=null,
)//55 graph
.addPanel(
  graphPanel.new(
  'Client Questions (All Host Groups)',//title
  fill=2,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  format = 'short',
  value_type='cumulative',
  stack=true,
  )
  .addTarget(
    prometheus.target(
    'rate(proxysql_mysql_status_questions{node_name="$proxysql"}[$interval]) or irate(proxysql_mysql_status_questions{node_name="$proxysql"}[5m])',
    intervalFactor = 1,
    legendFormat='Question Rate',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=60,
    )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 6,
  },style=null,
)//56 graph
.addPanel(
    row.new(
      title='Connection Pool Usage',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 13,
    },
    style=null,
)//69 row
.addPanel(
  tablePanel.new(
    title='Endpoint Status',
    datasource='Prometheus',
    description='Status number to state mapping:

    1 `ONLINE`

    2 `SHUNNED`

    3 `OFFLINE_SOFT`

    4 `OFFLINE_HARD`

    For status details, see the [description](https://github.com/sysown/proxysql/blob/master/doc/admin_tables.md#mysql_servers).',
    fontSize='100%',
    scroll=true,
    showHeader=true,
    sort={
      "col": 3,
      "desc": false,
    },
    columns=[
        {
          "text": "Current",
          "value": "current"
        }
      ],

  )
    .addStyle(
      {
        "alias": "Status",
        "colorMode": "cell",
        "colors": [
          "rgba(50, 172, 45, 0.97)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(245, 54, 54, 0.9)"
        ],
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 0,
        "mappingType": 1,
        "pattern": "Value",
        "thresholds": [
          "3",
          "4"
        ],
        "type": "string",
        "unit": "none",
        "valueMaps": [
          {
            "text": "ONLINE",
            "value": "1"
          },
          {
            "text": "SHUNNED",
            "value": "2"
          },
          {
            "text": "OFFLINE_SOFT",
            "value": "3"
          },
          {
            "text": "OFFLINE_HARD",
            "value": "4"
          }
        ]
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
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "pattern": "__name__",
        "thresholds": [],
        "type": "hidden",
        "unit": "short"
      },
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
            "dateFormat": "YYYY-MM-DD HH:mm:ss",
            "decimals": 2,
            "pattern": "Time",
            "thresholds": [],
            "type": "hidden",
            "unit": "short"
          },
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
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "pattern": "job",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        },
      )
    .addTarget(
    prometheus.target(
      'proxysql_connection_pool_status{node_name="$proxysql", hostgroup=~"$hostgroup"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      instant=true,
      format='table',
      legendFormat='{{ endpoint }}',
   )
   ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 14,
    },
    style=null,
)//57 table
.addPanel(
    row.new(
      title='Connections',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 21,
    },
    style=null,
)//70 row
.addPanel(
  graphPanel.new(
  'Active Backend Connections',//title
  fill=2,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  format = 'short',
  value_type='cumulative',
  stack=true,
  )
  .addTarget(
    prometheus.target(
    'proxysql_connection_pool_conn_used{node_name="$proxysql", hostgroup=~"$hostgroup"}',
    intervalFactor = 1,
    legendFormat='{{ endpoint }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=60,
    )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 22,
  },style=null,
)//51 graph
.addPanel(
  graphPanel.new(
  'Failed Backend Connections',//title
  fill=2,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  format = 'short',
  value_type='cumulative',
  stack=true,
  )
  .addTarget(
    prometheus.target(
    'rate(proxysql_connection_pool_conn_err{node_name="$proxysql", hostgroup=~"$hostgroup"}[$interval]) or irate(proxysql_connection_pool_conn_err{node_name="$proxysql", hostgroup=~"$hostgroup"}[5m])',
    intervalFactor = 1,
    legendFormat='{{ endpoint }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=60,
    )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 22,
  },style=null,
)//52 graph
.addPanel(
  graphPanel.new(
  'Active Frontend Connections',//title
  fill=2,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_sort='avg',
  legend_sortDesc=true,
  editable=true,
  format = 'short',
  value_type='cumulative',
  stack=true,
  )
  .addTarget(
    prometheus.target(
    'max_over_time(proxysql_processlist_client_connection_list[$interval]) or max_over_time(proxysql_processlist_client_connection_list[5m])',
    intervalFactor = 1,
    legendFormat='{{ client_host }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=60,
    )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 29,
  },style=null,
)//76 graph
.addPanel(
    row.new(
      title='Network',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 36,
    },
    style=null,
)//71 row
.addPanel(
  graphPanel.new(
  'Queries Routed',//title
  fill=2,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  format = 'short',
  value_type='cumulative',
  )
  .addTarget(
    prometheus.target(
    'rate(proxysql_connection_pool_queries{node_name="$proxysql", hostgroup=~"$hostgroup"}[$interval]) or irate(proxysql_connection_pool_queries{node_name="$proxysql", hostgroup=~"$hostgroup"}[5m])',
    intervalFactor = 1,
    legendFormat='{{ endpoint }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=60,
    )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 37,
  },style=null,
)//2 graph
.addPanel(
  graphPanel.new(
  'Query processor time efficecy',//title
  fill=1,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_total=true,
  legend_current=true,
  editable=true,
  formatY1 = 'short',
  formatY2 = 'ns',
  )
  .addSeriesOverride(
     {
        "alias": "QP_efficiency_query",
        "yaxis": 2
     }
  )
  .addSeriesOverride(
    {
        "alias": "QP_time",
        "yaxis": 2
    }
  )
  .addTarget(
    prometheus.target(
    '(rate(proxysql_mysql_status_query_processor_time_nsec{node_name="$proxysql"}[$interval]) or irate(proxysql_mysql_status_query_processor_time_nsec{node_name="$proxysql"}[5m]))/(rate(proxysql_mysql_status_questions{node_name="$proxysql"}[$interval]) or irate(proxysql_mysql_status_questions{node_name="$proxysql"}[5m]))',
    intervalFactor = 1,
    legendFormat='QP_efficiency_query',
    refId='A',
    interval='',
    step=10,
    hide=false,
    )
  )
  .addTarget(
      prometheus.target(
      '(rate(proxysql_mysql_status_query_processor_time_nsec{node_name="$proxysql"}[$interval]) or irate(proxysql_mysql_status_query_processor_time_nsec{node_name="$proxysql"}[5m]))',
      intervalFactor = 1,
      legendFormat='QP_time',
      refId='B',
      step=1,
      hide=true,
      )
      )
  .addTarget(
          prometheus.target(
          '(rate(proxysql_mysql_status_questions{node_name="$proxysql"}[$interval]) or irate(proxysql_mysql_status_questions{node_name="$proxysql"}[5m]))',
          intervalFactor = 1,
          legendFormat='Questions',
          refId='C',
          step=10,
          )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 37,
  },style=null,
)//59 graph
.addPanel(
    row.new(
      title='Queries',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 44,
    },
    style=null,
)//72 row
.addPanel(
  graphPanel.new(
  'Connection Free',//title
  fill=2,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  format = 'short',
  value_type='cumulative',
  )
  .addTarget(
    prometheus.target(
    'proxysql_connection_pool_conn_free{node_name="$proxysql", hostgroup=~"$hostgroup"}',
    intervalFactor = 1,
    legendFormat='{{ endpoint }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=60,
    )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 45,
  },style=null,
)//60 graph
.addPanel(
  graphPanel.new(
  'Latency',//title
  fill=2,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  formatY1 = 'µs',
  formatY2 = 'short',
  value_type='cumulative',
  )
  .addTarget(
    prometheus.target(
    'proxysql_connection_pool_latency_us{node_name="$proxysql", hostgroup=~"$hostgroup"}',
    intervalFactor = 1,
    legendFormat='{{ endpoint }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=60,
    )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 45,
  },style=null,
)//50 graph
.addPanel(
    row.new(
      title='Query Cache',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 52,
    },
    style=null,
)//73 row
.addPanel(
  graphPanel.new(
  'Query Cache memory',//title
  fill=1,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_total=true,
  legend_current=true,
  editable=true,
  format= 'bytes',
  )
  .addSeriesOverride(
      {
        "alias": "Bytes for cached query avg",
        "yaxis": 2
      }
  )
  .addTarget(
    prometheus.target(
    'proxysql_mysql_status_query_cache_memory_bytes{node_name="$proxysql"}',
    intervalFactor = 1,
    legendFormat='QC Total Memory used',
    refId='A',
    interval='',
    hide=false,
    step=10,
    )
    )
  .addTarget(
      prometheus.target(
      'proxysql_mysql_status_query_cache_memory_bytes{node_name="$proxysql"}/proxysql_mysql_status_query_cache_entries{node_name="$proxysql"}',
      intervalFactor = 1,
      legendFormat='Bytes for cached query avg',
      refId='B',
      step=10,
      )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 53,
  },style=null,
)//62 graph
.addPanel(
  graphPanel.new(
  'Query Cache efficiency',//title
  fill=2,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  format= 'percent',
  value_type='cumulative',
  )
  .addSeriesOverride(
    {
     "alias": "Insert VS read efficnecy (high is good)",
     "yaxis": 2
    }
  )
  .addTarget(
    prometheus.target(
    '((rate(proxysql_mysql_status_query_cache_count_get_ok{node_name="$proxysql"}[$interval]) + rate(proxysql_mysql_status_query_cache_count_get_ok{node_name="$proxysql"}[$interval])) or (irate(proxysql_mysql_status_query_cache_count_get_ok{node_name="$proxysql"}[5m]) + irate(proxysql_mysql_status_query_cache_count_get_ok{node_name="$proxysql"}[5m]))/(rate(proxysql_mysql_status_query_cache_count_get{node_name="$proxysql"}[$interval]) + rate(proxysql_mysql_status_query_cache_count_get{node_name="$proxysql"}[$interval])) or (irate(proxysql_mysql_status_query_cache_count_get{node_name="$proxysql"}[5m]) + irate(proxysql_mysql_status_query_cache_count_get{node_name="$proxysql"}[5m])))',
    intervalFactor = 1,
    legendFormat='Query Cache GET efficiency',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=60,
    )
    )
  .addTarget(
      prometheus.target(
      '((rate(proxysql_mysql_status_query_cache_bytes_out{node_name="$proxysql"}[$interval]) + rate(proxysql_mysql_status_query_cache_bytes_out{node_name="$proxysql"}[$interval])) or (irate(proxysql_mysql_status_query_cache_bytes_out{node_name="$proxysql"}[5m]) + irate(proxysql_mysql_status_query_cache_bytes_out{node_name="$proxysql"}[5m]))/(rate(proxysql_mysql_status_query_cache_bytes_in{node_name="$proxysql"}[$interval]) + rate(proxysql_mysql_status_query_cache_bytes_in{node_name="$proxysql"}[$interval])) or (irate(proxysql_mysql_status_query_cache_bytes_in{node_name="$proxysql"}[5m]) + irate(proxysql_mysql_status_query_cache_bytes_in{node_name="$proxysql"}[5m])))',
      intervalFactor = 2,
      legendFormat='Insert VS read efficiency (high is good)',
      refId='B',
      step=20,
      )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 53,
  },style=null,
)//53 graph
.addPanel(
    row.new(
      title='Network Traffic and Mirroring efficiency',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 60,
    },
    style=null,
)//74 row
.addPanel(
  graphPanel.new(
  'Network Traffic',//title
  fill=2,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  formatY1= 'Bps',
  formatY2= 'short',
  value_type='cumulative',
  )
  .addTarget(
    prometheus.target(
    '(rate(proxysql_connection_pool_bytes_data_recv{node_name="$proxysql", hostgroup=~"$hostgroup"}[$interval]) + rate(proxysql_connection_pool_bytes_data_sent{node_name="$proxysql", hostgroup=~"$hostgroup"}[$interval])) or (irate(proxysql_connection_pool_bytes_data_recv{node_name="$proxysql", hostgroup=~"$hostgroup"}[5m]) + irate(proxysql_connection_pool_bytes_data_sent{node_name="$proxysql", hostgroup=~"$hostgroup"}[5m]))',
    intervalFactor = 1,
    legendFormat='{{ endpoint }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=60,
    )
  ),gridPos={
     "h": 7,
     "w": 12,
     "x": 0,
     "y": 61,
  },style=null,
)//65 graph
.addPanel(
  graphPanel.new(
  'Mirroring efficiency',//title
  fill=1,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_current=true,
  legend_total=true,
  format= 'short',
  )
  .addSeriesOverride(
    {
      "alias": "Concurrent Mirror threads",
      "yaxis": 2
    }
  )
  .addTarget(
    prometheus.target(
    'proxysql_mysql_status_mirror_concurrency{node_name="$proxysql"}',
    intervalFactor = 1,
    legendFormat='Concurrent Mirror threads',
    refId='A',
    interval='',
    hide=false,
    step=10,
    )
  )
  .addTarget(
      prometheus.target(
      'proxysql_mysql_status_mirror_queue_length{node_name="$proxysql"}',
      intervalFactor = 1,
      legendFormat='Mirror queue length (queries)',
      refId='B',
      step=20,
      )
  ),gridPos={
     "h": 7,
     "w": 12,
     "x": 12,
     "y": 61,
  },style=null,
)//61 graph
.addPanel(
    row.new(
      title='Memory',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 68,
    },
    style=null,
)//75 row
.addPanel(
  graphPanel.new(
  'Memory Utilization',//title
  fill=1,
  bars=true,
  linewidth=1,
  datasource='Prometheus',
  pointradius=5,
  lines=false,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  formatY1= 'bytes',
  formatY2= 'short',
  stack=true,
  )
  .addTarget(
    prometheus.target(
    'proxysql_mysql_status_query_cache_memory_bytes{node_name="$proxysql"}',
    intervalFactor = 2,
    legendFormat='Query Cache',
    refId='A',
    step=20,
    )
    )
  .addTarget(
      prometheus.target(
      'proxysql_mysql_status_sqlite3_memory_bytes{node_name="$proxysql"}',
      intervalFactor = 2,
      legendFormat='SQLite',
      refId='B',
      step=20,
      )
    )
  .addTarget(
        prometheus.target(
        'proxysql_mysql_status_connpool_memory_bytes{node_name="$proxysql"}',
        intervalFactor = 2,
        legendFormat='Connection Pool',
        refId='C',
        step=20,
        )
  ),gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 69,
  },style=null,
)//66 graph
