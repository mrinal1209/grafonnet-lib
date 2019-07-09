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
  'MongoDB InMemory',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=1,
  tags=['MongoDB','Percona'],
  iteration=1553598083400,
  uid="KPz9QMNmz",
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
  ),
)
.addTemplate(
  template.new(
  'host',
  'Prometheus',
  'label_values(mongodb_mongod_storage_engine{cluster=~"$cluster",engine="inMemory"}, node_name)',
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
  'label_values(mongodb_mongod_storage_engine{cluster=~"$cluster",node_name=~"$host",engine="inMemory"}, service_name)',
  label='Service',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='glob',
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  ),
)
.addPanel(
  singlestat.new(
    'InMemory Data Size',//title
    description='This panel shows the amount of data currently being stored InMemory. This data is in its uncompressed format and differs from how the data is stored on disk or in the file system cache. This value will always be lower than the counter shown in the *InMemory Max Data Size* panel.',
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    decimals=2,
    thresholds='',
    colors=[
     "rgba(245, 54, 54, 0.9)",
     "rgba(237, 129, 40, 0.89)",
     "rgba(50, 172, 45, 0.97)",
     ],
  )
  .addTarget(
    prometheus.target(
      'mongodb_mongod_wiredtiger_cache_bytes{service_name=~"$service", type="total"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      step=300,
    )
   ),
  gridPos = {
    "h": 4,
    "w": 6,
    "x": 0,
    "y": 0,
   },
  style=null,
)//62 singlestat
.addPanel(
  singlestat.new(
    'InMemory Max Data Size',//title
    description='This is the maximum size that the InMemory data can grow to and this value can be changed from the default value by setting the `storage.wiredTiger.inMemory.cacheSizeGB` value in the config file or passing in the `--inMemoryCacheSizeGB` parameter on the command line.',
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    decimals=2,
    thresholds='',
    colors=[
     "rgba(245, 54, 54, 0.9)",
     "rgba(237, 129, 40, 0.89)",
     "rgba(50, 172, 45, 0.97)",
     ],
  )
  .addTarget(
    prometheus.target(
      'mongodb_mongod_wiredtiger_cache_max_bytes{service_name=~"$service"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      step=300,
    )
   ),
  gridPos = {
    "h": 4,
    "w": 6,
    "x": 6,
    "y": 0,
   },
  style=null,
)//63 singlestat
.addPanel(
  singlestat.new(
    'InMemory Available',//title
    description='This panel shows the amount of memory left available for your InMemory databases.',
    format='percentunit',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    thresholds='90,95',
    prefixFontSize='80%',
    interval="$interval",
    height='125px',
    colorValue=true,
    sparklineFull=true,
    sparklineShow=true,
    valueMaps=[],
    colors=[
       "rgba(50, 172, 45, 0.97)",
       "rgba(237, 129, 40, 0.89)",
       "rgba(245, 54, 54, 0.9)",
     ],
  )
  .addTarget(
    prometheus.target(
      '1-(max(mongodb_mongod_wiredtiger_cache_bytes{service_name=~"$service", type="total"})/max(mongodb_mongod_wiredtiger_cache_max_bytes{service_name=~"$service"}))',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      calculatedInterval='10m',
      step=300,
      metric='node_mem',
    )
   ),
  gridPos = {
    "h": 4,
    "w": 6,
    "x": 12,
    "y": 0,
   },
  style=null,
)//69 singlestat
.addPanel(
  singlestat.new(
    'InMemory Dirty Pages',//title
    description='This panel shows the percentage of InMemory pages that have been changed and not yet had the modified data consolidated.',
    format='percentunit',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    thresholds='30,50',
    prefixFontSize='80%',
    interval="$interval",
    height='125px',
    colorValue=true,
    sparklineFillColor='rgba(189, 154, 31, 0.18)',
    sparklineFull=true,
    sparklineLineColor='rgb(193, 153, 31)',
    sparklineShow=true,
    valueMaps=[],
    colors=[
       "rgba(42, 150, 37, 0.97)",
       "rgba(237, 129, 40, 0.89)",
       "rgba(245, 54, 54, 0.9)",
     ],
  )
  .addTarget(
    prometheus.target(
      'avg(mongodb_mongod_wiredtiger_cache_pages{service_name=~"$service",type="dirty"})/avg(mongodb_mongod_wiredtiger_cache_pages{service_name=~"$service",type="total"})',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      calculatedInterval='10m',
      step=300,
      metric='node_mem',
    )
   ),
  gridPos = {
    "h": 4,
    "w": 6,
    "x": 18,
    "y": 0,
   },
  style=null,
)//70 singlestat
.addPanel(
  graphPanel.new(
    'InMemory Transactions',//title
    description='This panel shows statistics about the InMemory transactions operations and checkpoints over the given interval.',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_hideZero=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    value_type='cumulative',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_wiredtiger_transactions_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_wiredtiger_transactions_total{service_name=~"$service"}[5m])',
        refId='A',
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
        "y": 4,
        },
  style=null,
)//52 graph
.addPanel(
  graphPanel.new(
    'InMemory Capacity',//title
    description='This panel shows a graphical representation of the *InMemory Data Size* and *InMemory Max Data Size* at the top of this worksheet.',
    fill=2,
    linewidth=2,
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
  .addTarget(
      prometheus.target(
        'mongodb_mongod_wiredtiger_cache_max_bytes{service_name=~"$service"}',
        refId='C',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Maximum',
      )
   )
  .addTarget(
       prometheus.target(
         'mongodb_mongod_wiredtiger_cache_bytes{service_name=~"$service", type="total"}',
         refId='A',
         interval='$interval',
         step=300,
         intervalFactor=1,
         legendFormat='Used',
       )
    ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 4,
        },
  style=null,
)//45 graph
.addPanel(
  graphPanel.new(
    'InMemory Sessions',//title
    description='This panel shows information about the currently open WiredTiger sessions and cursors.',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    value_type='cumulative',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_wiredtiger_session_open_cursors_total{service_name=~"$service"}',
        refId='A',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Cursors',
      )
   )
  .addTarget(
       prometheus.target(
         'mongodb_mongod_wiredtiger_session_open_sessions_total{service_name=~"$service"}',
         refId='B',
         interval='$interval',
         step=300,
         intervalFactor=1,
         legendFormat='Sessions',
       )
    ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 11,
        },
  style=null,
)//60 graph
.addPanel(
  graphPanel.new(
    'InMemory Pages',//title
    description='This panel shows the number of pages in the InMemory cache.',
    fill=2,
    linewidth=2,
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
        'mongodb_mongod_wiredtiger_cache_pages{service_name=~"$service"}',
        refId='A',
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
    "y": 11,
        },
  style=null,
)//68 graph
.addPanel(
  graphPanel.new(
    'InMemory Concurrency Tickets',//title
    description='This panel shows the number of concurrent tickets available for reads and writes. These values are user configurable so you can tune read and write heavy applications as appropriate. The settings for changing these are the same as for changing the WiredTiger concurrent tickets.

    Learn how to configure [WiredTiger concurrency tickets](https://docs.mongodb.com/manual/reference/parameters/#wiredtiger-parameters).',
    fill=2,
    linewidth=2,
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
        'mongodb_mongod_wiredtiger_concurrent_transactions_total_tickets{service_name=~"$service"}-mongodb_mongod_wiredtiger_concurrent_transactions_out_tickets{service_name=~"$service"}',
        refId='A',
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
        },
  style=null,
)//55 graph
.addPanel(
  graphPanel.new(
    'Queued Operations',//title
    description='This shows the number of read and write operations that are waiting due to for a lock. Consistently small values here should not be of concern, but if the values are consistently high the queries causing long lock times should be tracked down and fixed.',
    fill=2,
    linewidth=2,
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
        'mongodb_mongod_global_lock_current_queue{service_name=~"$service"}',
        refId='J',
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
        },
  style=null,
)//40 graph
.addPanel(
  graphPanel.new(
    'Document Changes',//title
    description='This panel shows the average number of documents changed per second for the given time period. These changes are broken out by `update`, `delete` and `insert`. If this is a secondary node, then it will show the number of replicated commands.',
    fill=2,
    linewidth=2,
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
    minY1=0,
    formatY1='ops',
    stack=true,
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_document_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_document_total{service_name=~"$service"}[5m])',
        refId='J',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{state}}',
      )
    )
  .addTarget(
        prometheus.target(
          'rate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="delete"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="delete"}[5m])',
          refId='A',
          interval='$interval',
          step=300,
          intervalFactor=1,
          legendFormat='repl_deleted',
        )
      )
  .addTarget(
            prometheus.target(
              'rate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="update"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="update"}[5m])',
              refId='B',
              interval='$interval',
              step=300,
              intervalFactor=1,
              legendFormat='repl_updated',
            )
          )
  .addTarget(
    prometheus.target(
         'rate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="insert"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="insert"}[5m])',
         refId='C',
         interval='$interval',
         step=300,
         intervalFactor=1,
         legendFormat='repl_inserted',
                    )
                  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_ttl_deleted_documents_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_ttl_deleted_documents_total{service_name=~"$service"}[5m])',
        refId='D',
       interval='$interval',
       step=300,
       intervalFactor=1,
      legendFormat='ttl_deleted',
          )
      )
  ,gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 25
        },
  style=null,
)//36 graph
.addPanel(
  graphPanel.new(
    'InMemory Cache Eviction',//title
    description='This panel shows the number of pages that have been evicted from the WiredTiger cache for the given time period. The InMemory storage engine only evicts modified pages which signals a compaction of the data and removal of the dirty pages.',
    fill=6,
    linewidth=2,
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
    minY1=0,
    labelY1='Pages / sec',
    stack=true,
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_wiredtiger_cache_evicted_total{service_name=~"$service",type="modified"}[$interval]) or irate(mongodb_mongod_wiredtiger_cache_evicted_total{service_name=~"$service",type="modified"}[5m])',
        refId='A',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='Evicted',
      )
    ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 25
        },
  style=null,
)//53 graph
.addPanel(
  graphPanel.new(
    'Scanned and Moved Objects',//title
    description='This panel shows the number of objects (both data (scanned_objects) and index (scanned)). If the number of scanned_objects is much higher than the number for scanned check to make sure you have indexes to support your queries. Generally you want to see a higher value for scanned than for scanned_objects.',
    fill=2,
    linewidth=2,
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
    minY1=0,
    formatY1='ops',
    value_type='cumulative',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_query_executor_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_query_executor_total{service_name=~"$service"}[5m])',
        refId='A',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{state}}',
      )
    )
  .addTarget(
        prometheus.target(
          'rate(mongodb_mongod_metrics_record_moves_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_record_moves_total{service_name=~"$service"}[5m])',
          refId='B',
          interval='$interval',
          step=300,
          intervalFactor=1,
          legendFormat='moved',
        )
      )    ,
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 32
        },
  style=null,
)//32 graph
.addPanel(
  graphPanel.new(
    'Page Faults',//title
    description="Page faults indicate that requests are being processed from disk rather than from memory. This is due to there not being enough memory for the current working set. A low number here isn't generally a concern, but if this counter is consistently high, first check to make sure you have indexes on your collections to support the queries you normally run. If the counter stays high, you should consider increasing the server's memory or look into sharding your database.

    You can read more about [Page Faults](https://docs.mongodb.com/manual/administration/analyzing-mongodb-performance/#page-faults).",
    fill=2,
    linewidth=2,
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
    minY1=0,
    value_type='cumulative',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_extra_info_page_faults_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_extra_info_page_faults_total{service_name=~"$service"}[5m]) or rate(mongodb_extra_info_page_faults_total{service_name=~"$service"}[$interval]) or irate(mongodb_extra_info_page_faults_total{service_name=~"$service"}[5m])',
        refId='J',
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
    "y": 32
        },
  style=null,
)//39 graph
