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
  'MongoDB WiredTiger',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=16,
  version=1,
  tags=['MongoDB','Percona'],
  iteration=1553542521936,
  uid="tBkrQGNmz",
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
    'Home',
    ['Home'],
    type='link',
    url='/graph/d/Fxvd1timk/home-dashboard',
    keepTime=true,
    includeVars=true,
    asDropdown=false,
    icon='doc',
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
    'MongoDB',
    ['MongoDB'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'Services',
    ['Services'],
    keepTime=true,
    includeVars=false,
  )
)
.addLink(
  grafana.link.dashboards(
    'PMM',
    ['PMM'],
    keepTime=true,
    includeVars=false,
  )
)
.addTemplate(
    template.interval('interval', 'auto,1s,5s,1m,5m,1h,6h,1d', 'auto', label='Interval', auto_count=200, auto_min='1s'),
)
.addTemplate(
  template.new(
  'cluster',
  'Prometheus',
  'label_values(mongodb_up,cluster)',
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
  'label_values(mongodb_mongod_storage_engine{cluster=~"$cluster",engine="wiredTiger"}, node_name)',
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
  'label_values(mongodb_mongod_storage_engine{cluster=~"$cluster",node_name=~"$host",engine="wiredTiger"}, service_name)',
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
    'WiredTiger Cache Usage',//title
    description='This panel shows the amount of data currently stored in the WiredTiger cache. This data is in its uncompressed format and differs from how the data is stored on disk or in the file system cache. This value will always be lower than the counter shown in the *WiredTiger Max Cache Size* panel.',
    format='bytes',
    decimals=2,
    editable=true,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
       "rgba(237, 129, 40, 0.89)",
       "rgba(50, 172, 45, 0.97)"
    ],
    timeFrom='1m',
  )
  .addTarget(
    prometheus.target(
      'mongodb_mongod_wiredtiger_cache_bytes{service_name="$service", type="total"}',
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
    'WiredTiger Max Cache Size',//title
    description="This is the maximum size that the WiredTiger cache can grow to and can be changed from the default value by setting the `storage.wiredTiger.engineConfig.cacheSizeGB` value in the config file or passing in the `--wiredTigerCacheSizeGB` parameter on the command line.\n\nYou can read more about [setting the WiredTiger maximum cache size](https://docs.mongodb.com/manual/reference/configuration-options/#storage.wiredTiger.engineConfig.cacheSizeGB).",
    format='bytes',
    decimals=2,
    editable=true,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
       "rgba(237, 129, 40, 0.89)",
       "rgba(50, 172, 45, 0.97)"
    ],
    timeFrom='1m',
  )
  .addTarget(
    prometheus.target(
      'mongodb_mongod_wiredtiger_cache_max_bytes{service_name="$service"}',
      intervalFactor = 1,
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
    description="This is the amount of the file system memory in use.",
    format='bytes',
    decimals=2,
    editable=true,
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
      intervalFactor = 1,
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
)//66 singlestat
.addPanel(
  pmmSinglestat.new(
    'Memory Available',//title
    description='This panel shows how much of the system memory is free.',
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
    prefixFontSize='80%',
  )
  .addTarget(
    prometheus.target(
      '(node_memory_MemAvailable_bytes{node_name=~"$host"} or (node_memory_MemFree_bytes{node_name=~"$host"} + node_memory_Buffers_bytes{node_name=~"$host"} + node_memory_Cached_bytes{node_name=~"$host"})) / node_memory_MemTotal_bytes{node_name=~"$host"} * 100',
      intervalFactor = 1,
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
)//71 pmm-singlestat
.addPanel(
  graphPanel.new(
    'WiredTiger Transactions',//title
    description="This panel shows statistics about the WiredTiger transactions operations and checkpoints over the given interval.",
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
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
        'rate(mongodb_mongod_wiredtiger_transactions_total{service_name="$service"}[$interval]) or irate(mongodb_mongod_wiredtiger_transactions_total{service_name="$service"}[5m])',
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
      "y": 4
  },style=null
)//52 graph
.addPanel(
  graphPanel.new(
    'WiredTiger Cache Activity',//title
    description="This panel shows activity in WiredTiger cache for the given period.",
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
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
    formatY1='Bps',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_wiredtiger_cache_bytes_total{service_name="$service", type="read"}[$interval]) or irate(mongodb_mongod_wiredtiger_cache_bytes_total{service_name="$service", type="read"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Read into',
        )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_wiredtiger_cache_bytes_total{service_name="$service", type="written"}[$interval]) or irate(mongodb_mongod_wiredtiger_cache_bytes_total{service_name="$service", type="written"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Written from',
        )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 4
  },style=null
)//46 graph
.addPanel(
  graphPanel.new(
    'WiredTiger Block Activity',//title
    description="This panel shows the number of bytes that the WiredTiger block manager has processed over the given interval.",
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
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
    formatY1='Bps',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_wiredtiger_blockmanager_bytes_total{service_name="$service"}[$interval]) or irate(mongodb_mongod_wiredtiger_blockmanager_bytes_total{service_name="$service"}[5m])',
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
    "y": 11
  },style=null
)//48 graph
.addPanel(
  graphPanel.new(
    'WiredTiger Sessions',//title
    description="This panel shows information about the currently open WiredTiger sessions and cursors.",
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
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
        'mongodb_mongod_wiredtiger_session_open_cursors_total{service_name="$service"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Cursors',
        )
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_wiredtiger_session_open_sessions_total{service_name="$service"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Sessions',
        )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 11
  },style=null
)//60 graph
.addPanel(
  graphPanel.new(
    'WiredTiger Concurrency Tickets Available',//title
    description="This panel shows the number of concurrent tickets available for reads and writes. These values are user configurable so you can tune read and write heavy applications as appropriate.\n\nLearn how to configure [WiredTiger concurrency tickets](https://docs.mongodb.com/manual/reference/parameters/#wiredtiger-parameters).",
    fill=2,
    linewidth=2,
    decimals=null,
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
    value_type='cumulative',
    minY1=0,
  )
  .addSeriesOverride({
          "alias": "/^write_/",
          "transform": "negative-Y"
        })
  .addTarget(
      prometheus.target(
        'mongodb_mongod_wiredtiger_concurrent_transactions_total_tickets{service_name="$service"}-mongodb_mongod_wiredtiger_concurrent_transactions_out_tickets{service_name="$service"}',
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
     "y": 18
  },style=null
)//55 graph
.addPanel(
  graphPanel.new(
    'Queued Operations',//title
    description='This shows the number of read and write operations that are waiting due to for a lock. Consistently small values here should not be of concern, but if the values are consistently high the queries causing long lock times should be tracked down and fixed.',
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
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
        'mongodb_mongod_global_lock_current_queue{service_name="$service"}',
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
     "y": 18
  },style=null
)//40 graph
.addPanel(
  graphPanel.new(
    'WiredTiger Checkpoint Time',//title
    description='This panel shows the number of WiredTiger checkpoints that are currently running and how long they are taking.',
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
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
    formatY1='ms',
    logBase1Y=10,
  )
  .addSeriesOverride({
          "alias": "current"
        })
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_wiredtiger_transactions_checkpoint_milliseconds_total{service_name="$service"}[$interval]) or irate(mongodb_mongod_wiredtiger_transactions_checkpoint_milliseconds_total{service_name="$service"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='current',
        )
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_wiredtiger_transactions_checkpoint_milliseconds{service_name="$service"}',
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
)//57 graph
.addPanel(
  graphPanel.new(
    'WiredTiger Cache Eviction',//title
    description='This panel shows the number of pages that have been evicted from the WiredTiger cache for the given time period.',
    fill=6,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
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
    labelY1='Pages / sec',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_wiredtiger_cache_evicted_total{service_name="$service"}[$interval]) or irate(mongodb_mongod_wiredtiger_cache_evicted_total{service_name="$service"}[5m])',
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
          "y": 25
  },style=null
)//53 graph
.addPanel(
  graphPanel.new(
    'WiredTiger Cache Capacity',//title
    description='This panel shows a graphical representation of the *WiredTiger Cache Usage* and *WiredTiger Max Cache Size* at the top of this worksheet.',
    fill=2,
    linewidth=2,
    decimals=null,
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
    value_type='cumulative',
    minY1=0,
    formatY1='bytes',
  )
  .addSeriesOverride({
          "alias": "Percent Overhead",
          "yaxis": 2
        })
  .addTarget(
      prometheus.target(
        'mongodb_mongod_wiredtiger_cache_max_bytes{service_name="$service"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Max',
        )
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_wiredtiger_cache_bytes{service_name="$service", type="total"}',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Used',
        )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 32
  },style=null
)//45 graph
.addPanel(
  graphPanel.new(
    'WiredTiger Cache Pages',//title
    description='This panel shows the number of pages in the WiredTiger cache.',
    fill=2,
    linewidth=2,
    decimals=null,
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
    value_type='cumulative',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_wiredtiger_cache_pages{service_name="$service"}',
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
    "y": 32
  },style=null
)//68 graph
.addPanel(
  graphPanel.new(
    'WiredTiger Log Operations',//title
    description="This panel shows information about the number of operations performed on the WiredTiger write ahead log.\n\nLearn more about the [WiredTiger journal](https://docs.mongodb.com/manual/core/journaling/#journaling-and-the-wiredtiger-storage-engine).",
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
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
        'rate(mongodb_mongod_wiredtiger_log_operations_total{service_name="$service"}[$interval]) or irate(mongodb_mongod_wiredtiger_log_operations_total{service_name="$service"}[5m])',
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
        "y": 39
  },style=null
)//59 graph
.addPanel(
  graphPanel.new(
    'WiredTiger Log Activity',//title
    description="This panel shows information about the amount of data that has been written to the WiredTiger write ahead log.\n\nLearn more about the [WiredTiger journal](https://docs.mongodb.com/manual/core/journaling/#journaling-and-the-wiredtiger-storage-engine).",
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
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
    formatY1='Bps',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_wiredtiger_log_bytes_total{service_name="$service"}[$interval]) or irate(mongodb_mongod_wiredtiger_log_bytes_total{service_name="$service"}[5m])',
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
        "y": 39
  },style=null
)//58 graph
.addPanel(
  graphPanel.new(
    'WiredTiger Log Records',//title
    description="This panel shows information about the number of records written to the WiredTiger write ahead log. If the log record is less than 128 bytes it will not be compressed.\n\nLearn more about the [WiredTiger journal](https://docs.mongodb.com/manual/core/journaling/#journaling-and-the-wiredtiger-storage-engine).",
    fill=6,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
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
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_wiredtiger_log_records_total{service_name="$service"}[$interval]) or irate(mongodb_mongod_wiredtiger_log_records_total{service_name="$service"}[5m])',
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
    "y": 46
  },style=null
)//61 graph
.addPanel(
  graphPanel.new(
    'Document Changes',//title
    description="This panel shows the average number of documents changed per second for the given time period. These changes are broken out by `update`, `delete` and `insert`. If this is a secondary node, then it will show the number of replicated commands.",
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
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
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_document_total{service_name="$service"}[$interval]) or irate(mongodb_mongod_metrics_document_total{service_name="$service"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{state}}',
        )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_repl_total{service_name="$service", type="delete"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name="$service", type="delete"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='repl_deleted',
        )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_repl_total{service_name="$service", type="update"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name="$service", type="update"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='repl_updated',
        )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_repl_total{service_name="$service", type="insert"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name="$service", type="insert"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='repl_inserted',
        )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_ttl_deleted_documents_total{service_name="$service"}[$interval]) or irate(mongodb_mongod_metrics_ttl_deleted_documents_total{service_name="$service"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='ttl_deleted',
        )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 46
  },style=null
)//36 graph
.addPanel(
  graphPanel.new(
    'Scanned and Moved Objects',//title
    description="This panel shows the number of objects (both data (*scanned_objects*) and index (*scanned*)). If the number of *scanned_objects* is much higher than the number for *scanned* check to make sure you have indexes to support your queries. Generally you want to see a higher value for *scanned* than for *scanned_objects*.",
    fill=2,
    linewidth=2,
    decimals=null,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
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
    min=0,
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_query_executor_total{service_name="$service"}[$interval]) or irate(mongodb_mongod_metrics_query_executor_total{service_name="$service"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{state}}',
        )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_record_moves_total{service_name="$service"}[$interval]) or irate(mongodb_mongod_metrics_record_moves_total{service_name="$service"}[5m])',
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
        "y": 53
  },style=null
)//36 graph
.addPanel(
  graphPanel.new(
    'Page Faults',//title
    description="Page faults indicate that requests are being processed from disk rather than from memory. This is due to there not being enough memory for the current working set. A low number here isn't generally a concern, but if this counter is consistently high, first check to make sure you have indexes on your collections to support the queries you normally run. If the counter stays high, you should consider increasing the server's memory or look into sharding your database.\n\nYou can read more about [Page Faults](https://docs.mongodb.com/manual/administration/analyzing-mongodb-performance/#page-faults).",
    fill=2,
    linewidth=2,
    decimals=null,
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
    value_type='cumulative',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_extra_info_page_faults_total{service_name="$service"}[$interval]) or irate(mongodb_mongod_extra_info_page_faults_total{service_name="$service"}[5m]) or rate(mongodb_extra_info_page_faults_total{service_name="$service"}[$interval]) or irate(mongodb_extra_info_page_faults_total{service_name="$service"}[5m])',
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
        "y": 53
  },style=null
)//39 graph
