local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local singlestat = grafana.singlestat;
local pmmSinglestat = grafana.pmmSinglestat;

dashboard.new(
  'MongoDB MMAPv1',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=16,
  version=1,
  tags=['Percona','MongoDB'],
  iteration=1532528606776,
  uid="Cok9wMHik",
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
  multi=false,
  multiFormat='glob',
  allFormat='glob',
  includeAll=true,
  ),
)
.addTemplate(
  template.new(
  'host',
  'Prometheus',
  'label_values(mongodb_mongod_storage_engine{cluster=~"$cluster",engine="mmapv1"}, node_name)',
  allFormat='glob',
  label='Instance',
  refresh='load',
  sort=1,
  multi=false,
  multiFormat='glob',
  includeAll=true,
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(mongodb_mongod_storage_engine{cluster=~"$cluster",node_name=~"$host",engine="mmapv1"}, service_name)',
  label='Service',
  refresh='load',
  sort=1,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  allFormat='glob',
  multiFormat='glob',
  ),
)
.addPanel(
  singlestat.new(
    'MMAPv1 Lock Wait Ratio',//title
    format='short',
    datasource='Prometheus',
    decimals=0,
    editable=true,
    thresholds='90,95',
    height='125px',
    interval='$interval',
    sparklineFull=true,
    colors=[
        "rgba(50, 172, 45, 0.97)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(245, 54, 54, 0.9)"
      ],
    valueMaps=[],
    prefixFontSize='80%',
    valueName='current',
  )
  .addTarget(
    prometheus.target(
      '(sum(increase(mongodb_mongod_locks_time_acquiring_global_microseconds_total{service_name=~"$service",database="Database"}[$interval])) by (instance) / (increase(mongodb_mongod_instance_uptime_seconds{service_name=~"$service"}[$interval])*1000000)) or mongodb_mongod_global_lock_ratio{service_name=~"$service"}',
      intervalFactor = 1,
      interval='5m',
      metric='node_mem',
      calculatedInterval='10m',
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
)//88 singlestat
.addPanel(
  singlestat.new(
    'MMAPv1 Write Lock Time',//title
    format='ms',
    decimals=0,
    datasource='Prometheus',
    editable=true,
    thresholds='90,95',
    height='125px',
    interval='$interval',
    sparklineFull=true,
    colors=[
        "rgba(50, 172, 45, 0.97)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(245, 54, 54, 0.9)"
      ],
    valueMaps=[],
    prefixFontSize='80%',
    valueName='current',
  )
  .addTarget(
    prometheus.target(
      'rate(mongodb_mongod_locks_time_acquiring_global_microseconds_total{service_name=~"$service",database="Global",type="write"}[$interval]) or irate(mongodb_mongod_locks_time_acquiring_global_microseconds_total{service_name=~"$service",database="Global",type="write"}[5m])',
      intervalFactor = 1,
      interval='5m',
      metric='node_mem',
      calculatedInterval='10m',
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
)//89 singlestat
.addPanel(
  singlestat.new(
    'Memory Cached',//title
    format='bytes',
    decimals=2,
    datasource='Prometheus',
    editable=true,
    thresholds='',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
      ],
    valueFontSize='70%',
    timeFrom='1m',
  )
  .addTarget(
    prometheus.target(
      'node_memory_Cached_bytes{node_name=~"$host"}',
      intervalFactor = 1,
      interval='5m',
      step=300,
    )
  ),
  gridPos = {
        "h": 4,
        "w": 6,
        "x": 12,
        "y": 0,
  },
  style=null,
)//79 singlestat
.addPanel(
  pmmSinglestat.new(
    'Memory Available',//title
    format='percent',
    colorValue=true,
    datasource='Prometheus',
    thresholds='90,95',
    prefixFontSize='80%',
    sparklineShow=true,
    valueName='current',
  )
  .addTarget(
    prometheus.target(
      '(node_memory_MemAvailable_bytes{node_name=~"$host"} or (node_memory_MemFree_bytes{node_name=~"$host"} + node_memory_Buffers_bytes{node_name=~"$host"} + node_memory_Cached_bytes{node_name=~"$host"})) / node_memory_MemTotal_bytes{node_name=~"$host"} * 100',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
        "h": 4,
        "w": 6,
        "x": 18,
        "y": 0,
  },
  style=null,
)//93 singlestat
.addPanel(
  graphPanel.new(
    'Document Activity',//title
    fill=2,
    linewidth=2,
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
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_document_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_document_total{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{state}}',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_ttl_deleted_documents_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_ttl_deleted_documents_total{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='ttl_deleted',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="delete"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="delete"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='repl_deleted',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="insert"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="insert"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='repl_inserted',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="update"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type="update"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='repl_updated',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 0,
     "y": 4,
  },
  style=null,
)//36 graph
.addPanel(
  graphPanel.new(
    'MMAPv1 Lock Ratios',//title
    fill=2,
    linewidth=2,
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
    formatY1='none',
  )
  .addTarget(
      prometheus.target(
        '(sum(increase(mongodb_mongod_locks_time_locked_global_microseconds_total{service_name=~"$service",database="Database"}[$interval])) by (instance) / (increase(mongodb_mongod_instance_uptime_seconds{service_name=~"$service"}[$interval])*1000000)) or mongodb_mongod_global_lock_ratio{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Lock (pre-3.2 only)',
        metric='mongodb_mongod_global_lock_ratio',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        '(sum(increase(mongodb_mongod_locks_time_acquiring_global_microseconds_total{service_name=~"$service",database="Database"}[$interval])) by (instance) / (increase(mongodb_mongod_instance_uptime_seconds{service_name=~"$service"}[$interval])*1000000)) or mongodb_mongod_global_lock_ratio{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Lock Wait',
        metric='mongodb_mongod_global_lock_ratio',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 12,
     "y": 4,
  },
  style=null,
)//82 graph
.addPanel(
  graphPanel.new(
    'MMAPv1 Lock Wait Time',//title
    fill=2,
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
    value_type='cumulative',
    minY1=0,
    formatY1='µs',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_locks_time_acquiring_global_microseconds_total{service_name=~"$service",database=~"(Global|Database|MMAPV1Journal)"}[$interval]) or irate(mongodb_mongod_locks_time_acquiring_global_microseconds_total{service_name=~"$service",database=~"(Global|Database|MMAPV1Journal)"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{database}} {{type}}',
        metric='node_vmstat_nr_dirty',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 0,
      "y": 11
  },
  style=null,
)//83 graph
.addPanel(
  graphPanel.new(
    'MMAPv1 Page Faults',//title
    fill=2,
    linewidth=2,
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
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_extra_info_page_faults_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_extra_info_page_faults_total{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Faults',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 12,
      "y": 11
  },
  style=null,
)//39 graph
.addPanel(
  graphPanel.new(
    'MMAPv1 Journal Write Activity',//title
    fill=2,
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
    value_type='cumulative',
    minY1=0,
    formatY1='MBs',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_durability_journaled_megabytes{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_durability_journaled_megabytes{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Journaled',
        metric='node_vmstat_nr_dirty',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_durability_write_to_data_files_megabytes{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_durability_write_to_data_files_megabytes{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Write to Data Files',
        metric='node_vmstat_nr_dirty',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 18
  },
  style=null,
)//85 graph
.addPanel(
  graphPanel.new(
    'MMAPv1 Journal Commit Activity',//title
    fill=2,
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
    value_type='cumulative',
    minY1=0,
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_durability_commits{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_durability_commits{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{state}}',
        metric='node_vmstat_nr_dirty',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 18
  },
  style=null,
)//87 graph
.addPanel(
  graphPanel.new(
    'MMAPv1 Journaling Time',//title
    fill=2,
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
    minY1=0,
    formatY1='ms',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_durability_time_milliseconds_sum{service_name=~"$service",stage!="dt"}[$interval]) or irate(mongodb_mongod_durability_time_milliseconds_sum{service_name=~"$service",stage!="dt"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{stage}}',
        metric='node_vmstat_nr_dirty',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 25,
  },
  style=null,
)//84 graph
.addPanel(
  graphPanel.new(
    'MMAPv1 Journaling Time - 99th Percentile',//title
    fill=2,
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
    minY1=0,
    formatY1='ms',
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_durability_time_milliseconds{service_name=~"$service",quantile="0.99",stage!="dt"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{stage}}',
        metric='node_vmstat_nr_dirty',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 25,
  },
  style=null,
)//86 graph
.addPanel(
  graphPanel.new(
    'MMAPv1 Background Flushing Time',//title
    fill=2,
    linewidth=2,
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
    minY1=0,
    formatY1='ms',
    value_type='cumulative',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_background_flushing_average_milliseconds{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_background_flushing_average_milliseconds{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Background Flushing',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 32,
  },
  style=null,
)//91 graph
.addPanel(
  graphPanel.new(
    'Queued Operations',//title
    fill=2,
    linewidth=2,
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
    minY1=0,
    formatY1='ops',
    value_type='cumulative',
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_global_lock_current_queue{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{type}}',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 32,
  },
  style=null,
)//40 graph
.addPanel(
  graphPanel.new(
    'Client Operations',//title
    fill=2,
    linewidth=2,
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
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_total{service_name=~"$service", type!="command"}[$interval]) or irate(mongodb_mongod_op_counters_total{service_name=~"$service", type!="command"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{type}}',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type!~"(command|query|getmore)"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type!~"(command|query|getmore)"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='repl_{{type}}',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 39,
  },
  style=null,
)//60 graph
.addPanel(
  graphPanel.new(
    'Scanned and Moved Objects',//title
    fill=2,
    linewidth=2,
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
        intervalFactor=1,
        legendFormat='{{state}}',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_record_moves_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_record_moves_total{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='moved',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 39,
  },
  style=null,
)//32 graph
.addPanel(
  graphPanel.new(
    'MMAPv1 Memory Usage',//title
    fill=2,
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
    minY1=0,
    formatY1='bytes',
  )
  .addTarget(
      prometheus.target(
        'node_memory_Cached_bytes{service_name=~"$service"}-node_memory_Mapped_bytes{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Unmapped',
        metric='node_memory_Buffers',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'node_memory_Mapped_bytes{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Mapped',
        metric='node_memory_Map',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'node_memory_SwapCached_bytes{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Swap Cached',
        metric='node_memory_SwapCached',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 0,
     "y": 46,
  },
  style=null,
)//81 graph
.addPanel(
  graphPanel.new(
    'MMAPv1 Memory Dirty Pages',//title
    fill=2,
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
    value_type='cumulative',
    minY1=0,
    logBase1Y=10,
  )
  .addTarget(
      prometheus.target(
        'node_vmstat_nr_dirty{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Total Dirty Pages',
        metric='node_vmstat_nr_dirty',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'node_vmstat_nr_dirty_background_threshold{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Soft Dirty Page Threshold',
        metric='node_vmstat_nr_dirty_background_threshold',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'node_vmstat_nr_dirty_threshold{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Hard Dirty Page Threshold',
        metric='node_vmstat_nr_dirty_threshold',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 12,
     "y": 46,
  },
  style=null,
)//90 graph
