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
  'Clickhouse',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=16,
  version=1,
  tags=['Percona','Insight'],
  iteration=1544100146771,
  uid="IN4v2iPmz",
  gnetId=822,
  description='Clickhouse metrics',
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
    template.pmmCustom(
      'pmmhost',//name
      'constant',//type
      'pmm-server',//query
      skipUrlSync=false,
      hide=2,
      current='pmm-server',
      options=[
          {
            "text": "pmm-server",
            "value": "pmm-server"
          }
        ],
    )
)
.addPanel(
  text.new(
    content='<h1><i><font color=#5991A7><b><center>Data for </font><font color=#e68a00>$pmmhost</font> <font color=#5991A7> with</font> </font><font color=#e68a00>$interval</font> <font color=#5991A7>resolution</center></b></font></i></h1>',
    mode='html',
    transparent=true,
  ),
  gridPos={
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 0,
      },
  style=null,
)//17 text
.addPanel(
  singlestat.new(
    'DB Uptime',//title
    format='s',
    datasource='Prometheus',
    valueName='current',
    decimals=1,
    colorValue=true,
    thresholds='3600,86400',
    height='100px',
    postfixFontSize='80%',
    postfix='s',
  )
  .addTarget(
    prometheus.target(
      'max_over_time(clickhouse_uptime[$interval]) or max_over_time(clickhouse_uptime[5m])',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
   ),
  gridPos = {
        "h": 2,
        "w": 8,
        "x": 0,
        "y": 2,
        },
  style=null,
)//13 singlestat
.addPanel(
  singlestat.new(
    'RW Lock Readers Wait',//title
    format='ms',
    datasource='Prometheus',
    thresholds='',
    valueMaps=[
      {
        value: 'null',
        op: '=',
        text: '0',
      },
    ],
  )
  .addTarget(
    prometheus.target(
      'max_over_time(clickhouse_rw_lock_readers_wait_milliseconds_total[$interval]) or max_over_time(clickhouse_rw_lock_readers_wait_milliseconds_total[5m])',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
   ),
  gridPos = {
      "h": 2,
      "w": 8,
      "x": 8,
      "y": 2,
   },
  style=null,
)//15 singlestat
.addPanel(
  singlestat.new(
    'Disk Space Reserved for Merge',//title
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    maxPerRow=6,
    editable=true,
  )
  .addTarget(
    prometheus.target(
      'max_over_time(clickhouse_disk_space_reserved_for_merge[$interval]) or max_over_time(clickhouse_disk_space_reserved_for_merge[5m])',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
    ),
  gridPos = {
    "h": 2,
    "w": 8,
    "x": 16,
    "y": 2,
    },
  style=null,
)//19 singlestat
.addPanel(
  graphPanel.new(
    'Data Operations',//title
    fill=0,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideEmpty=false,
    legend_hideZero=false,
    legend_show=true,
    editable=true,
    nullPointMode='null as zero',
    format='short',
    value_type='cumulative',
    logBase1Y=2,
   )
  .addTarget(
      prometheus.target(
        'max_over_time(clickhouse_read[$interval]) or max_over_time(clickhouse_read[5m])',
        refId='A',
        interval='$interval',
        step=10,
        intervalFactor=1,
        legendFormat='Read'
      )
  )
  .addTarget(
      prometheus.target(
        'max_over_time(clickhouse_write[$interval]) or max_over_time(clickhouse_write[5m])',
        interval='$interval',
        step=10,
        intervalFactor=1,
        legendFormat='Write'
      )
  )
  .addTarget(
      prometheus.target(
        'max_over_time(clickhouse_merge[$interval]) or max_over_time(clickhouse_merge[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Merge'
      )
  )
  .addTarget(
      prometheus.target(
        'max_over_time(clickhouse_background_pool_task[$interval]) or max_over_time(clickhouse_background_pool_task[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Background Pool'
      )
  )
  .addTarget(
      prometheus.target(
        'max_over_time(clickhouse_revision[$interval]) or max_over_time(clickhouse_revision[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Revision'
      )
  )
  .addTarget(
      prometheus.target(
        'rate(clickhouse_seek_total[$interval]) or irate(clickhouse_seek_total[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Seek'
      )
  )
  .addTarget(
      prometheus.target(
        'max_over_time(clickhouse_delayed_inserts[$interval]) or max_over_time(clickhouse_delayed_inserts[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Delayed Inserts'
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 4,
    },
  style=null,
)//4 graph
.addPanel(
  graphPanel.new(
    'Clickhouse Queries',//title
    fill=2,
    linewidth=2,
    decimals=0,
    datasource='Prometheus',
    pointradius=1,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_hideEmpty=true,
    legend_hideZero=true,
    legend_show=true,
    editable=true,
    nullPointMode='null as zero',
    format='short',
    value_type='cumulative',
   )
  .addTarget(
      prometheus.target(
        'rate(clickhouse_query_total[$interval]) or rate(clickhouse_query_total[5m])',
        refId='A',
        interval='$interval',
        step=10,
        intervalFactor=1,
        legendFormat='Queries',
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 11,
    },
  style=null,
)//1 graph
.addPanel(
  graphPanel.new(
    'Mark Cache',//title
    description="Mark cache - Cache of 'marks' for StorageMergeTree. Marks is an index structure that addresses ranges in column file, corresponding to ranges of primary key",
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_hideZero=false,
    legend_show=true,
    editable=true,
    formatY1='short',
    formatY2='bytes',
    value_type='cumulative',
    min='0',
   )
  .addSeriesOverride(
      {
        "alias": "Size",
        "yaxis": 2
      }
  )
  .addTarget(
      prometheus.target(
        'rate(clickhouse_mark_cache_misses_total[$interval]) or irate(clickhouse_mark_cache_misses_total[5m])',
        refId='A',
        interval='$interval',
        step=4,
        intervalFactor=1,
        legendFormat='Misses'
      )
  )
  .addTarget(
      prometheus.target(
        'rate(clickhouse_mark_cache_hits_total[$interval]) or irate(clickhouse_mark_cache_hits_total[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Hits',
        step=4,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(clickhouse_mark_cache_bytes[$interval])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Size',
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 11,
    },
  style=null,
)//11 graph
.addPanel(
  graphPanel.new(
    'Compressed Read Buffer',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_hideZero=false,
    legend_show=true,
    editable=true,
    formatY2='short',
    formatY1='bytes',
    value_type='cumulative',
    nullPointMode='null as zero',
   )
   .resetYaxes()
   .addYaxis(
     format='bytes',
     label='bytes/sec',
     logBase=2,
   )
   .addYaxis(
     label='blocks',
     decimals=2,
   )
  .addSeriesOverride(
      {
        "alias": "Blocks",
        "yaxis": 2
      }
  )
  .addTarget(
      prometheus.target(
        'rate(clickhouse_compressed_read_buffer_bytes_total[1m])',
        refId='A',
        interval='$interval',
        step=10,
        intervalFactor=1,
        legendFormat='Size'
      )
  )
  .addTarget(
      prometheus.target(
        'clickhouse_compressed_read_buffer_blocks_total',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Blocks',
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 18,
    },
  style=null,
)//8 graph
.addPanel(
  graphPanel.new(
    'Connections',//title
    fill=0,
    linewidth=2,
    lines=false,
    points=true,
    decimals=0,
    datasource='Prometheus',
    pointradius=1,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_hideZero=false,
    legend_show=true,
    editable=true,
    format='short',
    value_type='cumulative',
    nullPointMode='null as zero',
   )
  .addTarget(
      prometheus.target(
        'max_over_time(clickhouse_tcp_connection[$interval]) or max_over_time(clickhouse_tcp_connection[5m])',
        refId='A',
        interval='$interval',
        step=10,
        intervalFactor=1,
        legendFormat='TCP',
      )
  )
  .addTarget(
      prometheus.target(
        'max_over_time(clickhouse_http_connection[$interval]) or max_over_time(clickhouse_http_connection[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='HTTP',
        step=10,
      )
  )
  .addTarget(
      prometheus.target(
        'clickhouse_interserver_connection',
        interval='$interval',
        intervalFactor=2,
        legendFormat='Interserver',
        step=10,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 18,
    },
  style=null,
)//5 graph
.addPanel(
  graphPanel.new(
    'Memory Tracking',//title
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_hideEmpty=true,
    legend_hideZero=true,
    legend_show=true,
    editable=true,
    formatY2='short',
    formatY1='bytes',
    value_type='cumulative',
    nullPointMode='null',
    logBase1Y=2,
    min=0,
   )
  .addTarget(
      prometheus.target(
        'max_over_time(clickhouse_memory_tracking[$interval]) or max_over_time(clickhouse_memory_tracking[5m])',
        refId='A',
        interval='$interval',
        step=10,
        intervalFactor=1,
        legendFormat='Memory',
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 25,
    },
  style=null,
)//10 graph
.addPanel(
  graphPanel.new(
    'File Opens',//title
    fill=2,
    decimals=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    format='short',
    nullPointMode='null',
    logBase1Y=2,
   )
  .addTarget(
      prometheus.target(
        'rate(clickhouse_file_open_total[$interval]) or irate(clickhouse_file_open_total[5m])',
        refId='A',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Operations',
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 25,
    },
  style=null,
)//21 graph
