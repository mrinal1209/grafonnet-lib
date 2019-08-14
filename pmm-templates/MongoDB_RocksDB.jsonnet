local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local row = grafana.row;
local singlestat = grafana.singlestat;
local pmmSinglestat = grafana.pmmSinglestat;
local pmm = grafana.pmm;



dashboard.new(
  'MongoDB RocksDB',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=16,
  version=1,
  tags=['MongoDB','Percona'],
  iteration=1532528966222,
  uid="EQzrQGNmk",
  timepicker = timepicker.new(
      hidden=false,
      now=true,
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
  'cluster',
  'Prometheus',
  'label_values(cluster)',
  label='Cluster',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='glob',
  multi=false,
  skipUrlSync=false,
  includeAll=true,
  )
)
.addTemplate(
  template.new(
  'host',
  'Prometheus',
  'label_values(mongodb_mongod_storage_engine{cluster=~"$cluster", engine="rocksdb"}, node_name)',
  label='Instance',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='glob',
  multi=false,
  skipUrlSync=false,
  includeAll=true,
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(mongodb_mongod_storage_engine{cluster=~\"$cluster\",node_name=~\"$host\",engine=\"rocksdb\"}, service_name)',
  label='Service',
  refresh='load',
  sort=1,
  allFormat='glob',
  multi=false,
  multiFormat='glob',
  skipUrlSync=false,
  includeAll=false,
  ),
)
.addTemplate(
  template.new(
  'level',
  'Prometheus',
  'label_values(mongodb_mongod_rocksdb_files{cluster=~"$cluster",node_name=~"$host",service_name=~"$service",level!="total"}, level)',
  label='RocksDB Level',
  refresh='time',
  sort=1,
  multi=true,
  includeAll=true,
  ),
)
.addPanel(
  pmm.new(
    ' ',
    'digiapulssi-breadcrumb-panel',
    isRootDashboard=false,
    transparent=true,
  )
  .addTarget(
  prometheus.target(
    '',
    intervalFactor=1,
    )
  ),
  gridPos={
        "h": 3,
        "w": 24,
        "x": 0,
        "y": 0
      },
  style=null
)//999 pmm
.addPanel(
  singlestat.new(
    'RocksDB Memtable Used',//title
    format='percentunit',
    editable=true,
    datasource='Prometheus',
    valueName='current',
    thresholds='98,100',
    hideTimeOverride=true,
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)",
    ],
    sparklineFull=true,
    timeFrom='5m',
    sparklineFillColor='rgba(200, 183, 73, 0.18)',
    sparklineLineColor='rgb(193, 166, 31)',
  )
  .addTarget(
    prometheus.target(
      'mongodb_mongod_rocksdb_memtable_bytes{service_name=~"$service", type="total"}/67108864',
      intervalFactor = 1,
      interval='5m',
      step=300,
    )
  ),
  gridPos={
     "h": 4,
     "w": 6,
     "x": 0,
     "y": 0
  },
  style=null,
)//62 singlestat
.addPanel(
  singlestat.new(
    'RocksDB Block Cache Used',//title
    format='bytes',
    editable=true,
    decimals=2,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    hideTimeOverride=true,
    colors=[
        "rgba(245, 54, 54, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(50, 172, 45, 0.97)"
    ],
    timeFrom='5m',
  )
  .addTarget(
    prometheus.target(
      'mongodb_mongod_rocksdb_block_cache_bytes{service_name=~"$service"}',
      intervalFactor=1,
      interval='5m',
      step=300,
    )
  ),
  gridPos={
     "h": 4,
     "w": 6,
     "x": 6,
     "y": 0
  },
  style=null,
)//63 singlestat
.addPanel(
  singlestat.new(
    'Memory Cached',//title
    format='bytes',
    editable=true,
    decimals=2,
    datasource='Prometheus',
    valueName='avg',
    thresholds='',
    hideTimeOverride=true,
    colors=[
        "rgba(245, 54, 54, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(50, 172, 45, 0.97)"
    ],
    timeFrom='1m',
    valueFontSize='70%',
  )
  .addTarget(
    prometheus.target(
      'node_memory_Cached_bytes{node_name=~"$host"}',
      intervalFactor=1,
      interval='5m',
      step=300,
    )
  ),
  gridPos={
     "h": 4,
     "w": 6,
     "x": 12,
     "y": 0
  },
  style=null,
)//79 singlestat
.addPanel(
  pmmSinglestat.new(
    'Memory Available',//title
    format='percent',
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='90,95',
    colorValue=true,
    colors=[
      "#299c46",
     "rgba(237, 129, 40, 0.89)",
     "#d44a3a"
    ],
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      '(node_memory_MemAvailable_bytes{node_name=~"$host"} or (node_memory_MemFree_bytes{node_name=~"$host"} + node_memory_Buffers_bytes{node_name=~"$host"} + node_memory_Cached_bytes{node_name=~"$host"})) / node_memory_MemTotal_bytes{node_name=~"$host"} * 100',
      intervalFactor=1,
      interval='$interval',
    )
  ),
  gridPos={
     "h": 4,
     "w": 6,
     "x": 18,
     "y": 0
  },
  style=null,
)//90 pmm-singlestat
.addPanel(
  graphPanel.new(
    'Document Activity',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_hideZero=true,
    editable=true,
    stack=true,
    formatY1='ops',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_document_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_document_total{service_name=~"$service"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{state}}',
        )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_ttl_deleted_documents_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_ttl_deleted_documents_total{service_name=~"$service"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='ttl_deleted',
        )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="delete"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="delete"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='repl_deleted',
        )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="insert"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="insert"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='repl_inserted',
        )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="update"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="update"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='repl_updated',
        )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 4
  },style=null
)//36 graph
.addPanel(
  graphPanel.new(
    'RocksDB Cache Usage',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    value_type='cumulative',
    formatY1='bytes',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_memtable_bytes{service_name=~"$service"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='memtable_{{type}}',
        )
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_block_cache_bytes{service_name=~"$service"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='block_cache_total',
        )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 4
  },style=null
)//48 graph
.addPanel(
  graphPanel.new(
    'RocksDB Memtable Entries',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_memtable_entries{service_name=~"$service"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{type}}',
        metric='mongodb_mongod_rocksdb_memtable_entries',
        )
  ),
  gridPos={
    "h": 7,
   "w": 12,
   "x": 0,
   "y": 11
  },style=null
)//69 graph
.addPanel(
  graphPanel.new(
    'RocksDB Block Cache Hit Ratio',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=false,
    editable=true,
    value_type='cumulative',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_rocksdb_block_cache_hits_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_rocksdb_block_cache_hits_total{service_name=~"$service"}[5m])/rate(mongodb_mongod_rocksdb_block_cache_misses_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_rocksdb_block_cache_misses_total{service_name=~"$service"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Hit Ratio',
        )
  ),
  gridPos={
   "h": 7,
   "w": 12,
   "x": 12,
   "y": 11
  },style=null
)//87 graph
.addPanel(
  graphPanel.new(
    'RocksDB Write Activity',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    editable=true,
    stack=true,
    minY1=0,
    formatY1='Bps',
    labelY1='Bytes / Sec',
  )
  .addSeriesOverride({
          "alias": "Total",
          "fill": 0,
          "stack": false
        })
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_rocksdb_bytes_written_total{service_name=~"$service",type!="total"}[$interval]) or irate(mongodb_mongod_rocksdb_bytes_written_total{service_name=~"$service",type!="total"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{type}}',
        metric='mongodb_mongod_rocksdb_writes_per_second',
        )
  ),
  gridPos={
       "h": 7,
       "w": 12,
       "x": 0,
       "y": 18
  },style=null
)//52 graph
.addPanel(
  graphPanel.new(
    'RocksDB Read Activity',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    stack=true,
    minY1=0,
    formatY1='Bps',
    labelY1='Bytes / Sec',
  )
  .addSeriesOverride({
          "alias": "Total",
          "fill": 0,
          "stack": false
        })
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_rocksdb_bytes_read_total{service_name=~"$service",type!="total"}[$interval]) or irate(mongodb_mongod_rocksdb_bytes_read_total{service_name=~"$service",type!="total"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{type}}',
        metric='mongodb_mongod_rocksdb_writes_per_second',
        )
  ),
  gridPos={
       "h": 7,
       "w": 12,
       "x": 12,
       "y": 18
  },style=null
)//85 graph
.addPanel(
  graphPanel.new(
    'RocksDB Level0 Read Latency',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
    formatY1='µs',
  )
  .addSeriesOverride({
          "alias": "Percent Overhead",
          "yaxis": 2
        })
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_read_latency_microseconds{service_name=~"$service",level="L0",type=~"(avg|min|max|P99)"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{type}}',
        )
  ),
  gridPos={
   "h": 7,
   "w": 12,
   "x": 0,
   "y": 25
  },style=null
)//81 graph
.addPanel(
  graphPanel.new(
    'RocksDB LevelN Read Average Latency',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
    formatY1='µs',
  )
  .addSeriesOverride({
          "alias": "Percent Overhead",
          "yaxis": 2
        })
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_read_latency_microseconds{service_name=~"$service",level=~"$level",level!="L0",type="avg"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{level}}',
        )
  ),
  gridPos={
   "h": 7,
   "w": 12,
   "x": 12,
   "y": 25
  },style=null
)//88 graph
.addPanel(
  graphPanel.new(
    'RocksDB LevelN 99th Percentile Read Latency',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
    formatY1='µs',
  )
  .addSeriesOverride({
          "alias": "Percent Overhead",
          "yaxis": 2
        })
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_read_latency_microseconds{service_name=~"$service",level=~"$level",level!="L0",type="P99"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{level}}',
        )
  ),
  gridPos={
   "h": 7,
   "w": 12,
   "x": 0,
   "y": 32
  },style=null
)//82 graph
.addPanel(
  graphPanel.new(
    'RocksDB LevelN Maximum Read Latency',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
    formatY1='µs',
  )
  .addSeriesOverride({
          "alias": "Percent Overhead",
          "yaxis": 2
        })
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_read_latency_microseconds{service_name=~"$service",level=~"$level",level!="L0",type=~"(max)"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{level}}',
        )
  ),
  gridPos={
   "h": 7,
   "w": 12,
   "x": 12,
   "y": 32
  },style=null
)//86 graph
.addPanel(
  graphPanel.new(
    'RocksDB Compaction Time',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_hideZero=true,
    editable=true,
    value_type='cumulative',
    min=0,
    formatY1='s',
    formatY2='none',
  )
  .addSeriesOverride({
          "alias": "/.*_count/",
          "yaxis": 2
        })
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_rocksdb_compaction_seconds_total{service_name=~"$service", level=~"$level"}[$interval]) or irate(mongodb_mongod_rocksdb_compaction_seconds_total{service_name=~"$service", level=~"$level"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{level}}',
        )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 39
  },style=null
)//71 graph
.addPanel(
  graphPanel.new(
    'RocksDB Compaction Write Amplification',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_hideZero=true,
    editable=true,
    value_type='cumulative',
    min=0,
    format='none',
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_compaction_write_amplification{service_name=~"$service",level=~"$level"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{level}}',
        )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 39
  },style=null
)//76 graph
.addPanel(
  graphPanel.new(
    'RocksDB Compaction Read Rate',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_hideZero=true,
    editable=true,
    stack=true,
    min=0,
    formatY1='Bps',
    formatY2='none',
  )
  .addSeriesOverride({
          "alias": "/write/",
          "transform": "negative-Y"
        })
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_rocksdb_compaction_bytes_per_second{service_name=~"$service", level=~"$level", type=~"read.*"}[$interval]) or irate(mongodb_mongod_rocksdb_compaction_bytes_per_second{service_name=~"$service", level=~"$level", type=~"read.*"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{level}}',
        metric="mongodb_mongod_rocksdb_compaction_bytes_per_second",
        )
  ),
  gridPos={
   "h": 7,
   "w": 12,
   "x": 0,
   "y": 46
  },style=null
)//72 graph
.addPanel(
  graphPanel.new(
    'RocksDB Compaction Write Rate',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    stack=true,
    min=0,
    formatY1='Bps',
    formatY2='s',
  )
  .addSeriesOverride({
          "alias": "seconds",
          "fill": 1,
          "linewidth": 1,
          "points": true,
          "yaxis": 2
        })
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_rocksdb_compaction_bytes_per_second{service_name=~"$service", level=~"$level", type=~"write.*"}[$interval]) or irate(mongodb_mongod_rocksdb_compaction_bytes_per_second{service_name=~"$service", level=~"$level", type=~"write.*"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{level}}',
        )
  ),
  gridPos={
   "h": 7,
   "w": 12,
   "x": 12,
   "y": 46
  },style=null
)//46 graph
.addPanel(
  graphPanel.new(
    'RocksDB Compaction Key Rate',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    stack=true,
    min=0,
    format='none',
  )
  .addSeriesOverride({
          "alias": "*_avg",
          "fill": 1
        })
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_rocksdb_compactions_total{service_name=~"$service", level=~"$level"}[$interval]) or irate(mongodb_mongod_rocksdb_compactions_total{service_name=~"$service", level=~"$level"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{level}}',
        metric='mongodb_mongod_rocksdb_compactions_total',
        )
  ),
  gridPos={
       "h": 7,
       "w": 12,
       "x": 0,
       "y": 53
  },style=null
)//73 graph
.addPanel(
  graphPanel.new(
    'RocksDB Compaction Threads',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
    format='none',
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_compaction_file_threads{service_name=~"$service", level=~"$level"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{level}}',
        metric='mongodb_mongod_rocksdb_compaction_file_threads',
        )
  ),
  gridPos={
       "h": 7,
       "w": 12,
       "x": 12,
       "y": 53
  },style=null
)//78 graph
.addPanel(
  graphPanel.new(
    'RocksDB Compaction Level Files',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
    format='none',
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_files{service_name=~"$service", level=~"$level"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{level}}',
        metric='mongodb_mongod_rocksdb_files',
        )
  ),
  gridPos={
   "h": 7,
   "w": 12,
   "x": 0,
   "y": 60
  },style=null
)//75 graph
.addPanel(
  graphPanel.new(
    'New row',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_hideZero=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
    formatY1='bytes',
    formatY2='percent',
    titleSize='h6',
  )
  .addSeriesOverride({
          "alias": "Syncs",
          "yaxis": 2
        })
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_size_bytes{service_name=~"$service", level=~"$level"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{level}}',
        )
  ),
  gridPos={
   "h": 7,
   "w": 12,
   "x": 12,
   "y": 60
  },style=null
)//74 graph
.addPanel(
  graphPanel.new(
    'RocksDB Write Ahead Log Rate',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=false,
    editable=true,
    value_type='cumulative',
    min=0,
    formatY1='Bps',
    formatY2='none',
  )
  .addSeriesOverride({
          "alias": "Syncs",
          "yaxis": 2
        })
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_write_ahead_log_bytes_per_second{service_name=~"$service"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Write Rate',
        metric='mongodb_mongod_rocksdb_write_ahead_log_bytes_per_second',
        )
  ),
  gridPos={
          "h": 7,
          "w": 12,
          "x": 0,
          "y": 67
  },style=null
)//56 graph
.addPanel(
  graphPanel.new(
    'RocksDB Write Ahead Log Sync Size',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=false,
    editable=true,
    value_type='cumulative',
    min=0,
    formatY2='none',
  )
  .addSeriesOverride({
          "alias": "Syncs",
          "yaxis": 2
        })
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_write_ahead_log_writes_per_sync{service_name=~"$service"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Writes per Sync',
        )
  ),
  gridPos={
          "h": 7,
          "w": 12,
          "x": 12,
          "y": 67
  },style=null
)//77 graph
.addPanel(
  graphPanel.new(
    'RocksDB Flush Rate',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
    formatY1='Bps',
  )
  .addSeriesOverride({
          "alias": "current"
        })
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_rocksdb_compaction_bytes_per_second{service_name=~"$service",level=~"$level"}[$interval]) or irate(mongodb_mongod_rocksdb_compaction_bytes_per_second{service_name=~"$service",level=~"$level"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{level}}_{{type}}',
        metric='rocksdb',
        )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 74
  },style=null
)//57 graph
.addPanel(
  graphPanel.new(
    'RocksDB Pending Operations',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
    formatY1='none',
  )
  .addSeriesOverride({
          "alias": "current"
        })
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_pending_compactions{service_name=~"$service"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='compactions',
        )
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_rocksdb_pending_memtable_flushes{service_name=~"$service"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='memtable_flushes',
        )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 74
  },style=null
)//70 graph
.addPanel(
  graphPanel.new(
    'RocksDB Stall Time',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=false,
    editable=true,
    value_type='cumulative',
    minY1=0,
    formatY1='s',
  )
  .addSeriesOverride({
          "alias": "Percent Overhead",
          "yaxis": 2
        })
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_rocksdb_stalled_seconds_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_rocksdb_stalled_seconds_total{service_name=~"$service"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Time Stalled',
        )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 81
  },style=null
)//45 graph
.addPanel(
  graphPanel.new(
    'RocksDB Stalls',//title
    fill=6,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_hideZero=true,
    editable=true,
    stack=true,
    minY1=0,
    formatY1='none',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_rocksdb_stalls_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_rocksdb_stalls_total{service_name=~"$service"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{type}}',
        )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 81
  },style=null
)//53 graph
.addPanel(
  graphPanel.new(
    'Client Operations',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_hideZero=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_total{service_name=~"$service", type!="command"}[$interval]) or irate(mongodb_mongod_op_counters_total{service_name=~"$service", type!="command"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{type}}',
        )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type!~"(command|query|getmore)"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type!~"(command|query|getmore)"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='repl_{{type}}',
        )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 0,
     "y": 88
  },style=null
)//60 graph
.addPanel(
  graphPanel.new(
    'Queued Operations',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
    formatY1='none',
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_global_lock_current_queue{service_name=~"$service"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{type}}',
        )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 12,
     "y": 88
  },style=null
)//40 graph
.addPanel(
  graphPanel.new(
    'Scanned and Moved Objects',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_hideZero=true,
    editable=true,
    value_type='cumulative',
    minY1=0,
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_query_executor_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_query_executor_total{service_name=~"$service"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{state}}',
        )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_record_moves_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_record_moves_total{service_name=~"$service"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='moved',
        )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 95
  },style=null
)//32 graph
.addPanel(
  graphPanel.new(
    'Page Faults',//title
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=false,
    editable=true,
    value_type='cumulative',
    minY1=0,
    formatY1='none',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_extra_info_page_faults_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_extra_info_page_faults_total{service_name=~"$service"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Faults',
        )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 95
  },style=null
)//39 graph
