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
  'PostgreSQL Overview',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=1,
  tags=['Percona','PostgreSQL'],
  iteration=1557128776047,
  uid="IvhES05ik",
  timepicker = timepicker.new(
    hidden=false,
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
  'work_mem',
  'Prometheus',
  'query_result(pg_settings_work_mem_bytes{service_name=~"$service"})',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  hide=2,
  ),
)
.addTemplate(
  template.new(
  'host',
  'Prometheus',
  'label_values(pg_up,node_name)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='glob',
  multi=false,
  skipUrlSync=false,
  definition='label_values(pg_up,node_name)',
  includeAll=false,
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(pg_up{node_name=~"$host"}, service_name)',
  definition='label_values(pg_up{node_name=~"$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  ),
)
.addTemplate(
  template.new(
  'db',
  'Prometheus',
  'label_values(pg_stat_database_tup_fetched{service_name=~"$service",datname!~"template.*|postgres"},datname)',
  label='DB',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  includeAll=true,
  ),
)
.addTemplate(
  template.new(
  'version',
  'Prometheus',
  'label_values(pg_static{service_name=~"$service"},version)',
  refresh=2,
  sort=2,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'max_connections',
  'Prometheus',
  'query_result(pg_settings_max_connections{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'shared_buffers',
  'Prometheus',
  'query_result(pg_settings_shared_buffers_bytes{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'wal_buffers',
  'Prometheus',
  'query_result(pg_settings_wal_buffers_bytes{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'wal_segment_size',
  'Prometheus',
  'query_result(pg_settings_wal_segment_size_bytes{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'maintenance_work_mem',
  'Prometheus',
  'query_result(pg_settings_maintenance_work_mem_bytes{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'block_size',
  'Prometheus',
  'query_result(pg_settings_block_size{service_name=~\"$service\"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'checkpoint_segments',
  'Prometheus',
  'query_result(pg_settings_checkpoint_segments{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'checkpoint_timeout',
  'Prometheus',
  'query_result(pg_settings_checkpoint_timeout_seconds{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'default_statistics_target',
  'Prometheus',
  'query_result(pg_settings_default_statistics_target{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'seq_page_cost',
  'Prometheus',
  'query_result(pg_settings_seq_page_cost{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'random_page_cost',
  'Prometheus',
  'query_result(pg_settings_random_page_cost{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'effective_cache_size',
  'Prometheus',
  'query_result(pg_settings_effective_cache_size_bytes{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'effective_io_concurrency',
  'Prometheus',
  'query_result(pg_settings_effective_io_concurrency{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'fsync',
  'Prometheus',
  'query_result(pg_settings_fsync{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'autovacuum',
  'Prometheus',
  'query_result(pg_settings_autovacuum{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'autovacuum_analyze_scale_factor',
  'Prometheus',
  'query_result(pg_settings_autovacuum_analyze_scale_factor{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'autovacuum_analyze_threshold',
  'Prometheus',
  'query_result(pg_settings_autovacuum_analyze_threshold{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'autovacuum_vacuum_scale_factor',
  'Prometheus',
  'query_result(pg_settings_autovacuum_vacuum_scale_factor{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'autovacuum_vacuum_threshold',
  'Prometheus',
  'query_result(pg_settings_autovacuum_vacuum_threshold{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'autovacuum_vacuum_cost_limit',
  'Prometheus',
  'query_result(pg_settings_autovacuum_vacuum_cost_limit{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'autovacuum_vacuum_cost_delay',
  'Prometheus',
  'query_result(pg_settings_autovacuum_vacuum_cost_delay_seconds{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'autovacuum_max_workers',
  'Prometheus',
  'query_result(pg_settings_autovacuum_max_workers{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'autovacuum_naptime',
  'Prometheus',
  'query_result(pg_settings_autovacuum_naptime_seconds{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'autovacuum_freeze_max_age',
  'Prometheus',
  'query_result(pg_settings_autovacuum_freeze_max_age{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'logging_collector',
  'Prometheus',
  'query_result(pg_settings_logging_collector{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'log_min_duration_statement',
  'Prometheus',
  'query_result(pg_settings_log_min_duration_statement_seconds{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'log_duration',
  'Prometheus',
  'query_result(pg_settings_log_duration{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'log_lock_waits',
  'Prometheus',
  'query_result(pg_settings_log_lock_waits{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'max_wal_senders',
  'Prometheus',
  'query_result(pg_settings_max_wal_senders{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'max_wal_size',
  'Prometheus',
  'query_result(pg_settings_max_wal_size_bytes{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'min_wal_size',
  'Prometheus',
  'query_result(pg_settings_min_wal_size_bytes{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'wal_compression',
  'Prometheus',
  'query_result(pg_settings_wal_compression{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'max_worker_processes',
  'Prometheus',
  'query_result(pg_settings_max_worker_processes{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'max_parallel_workers_per_gather',
  'Prometheus',
  'query_result(pg_settings_max_parallel_workers_per_gather{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'max_parallel_workers',
  'Prometheus',
  'query_result(pg_settings_max_parallel_workers_per_gather{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'autovacuum_work_mem',
  'Prometheus',
  'query_result(pg_settings_autovacuum_work_mem_bytes{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addTemplate(
  template.new(
  'autovacuum_multixact_freeze_max_age',
  'Prometheus',
  'query_result(pg_settings_autovacuum_multixact_freeze_max_age{service_name=~"$service"})',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  regex="/ ([0-9\\.]+)/",
  ),
)
.addPanel(
  text.new(
    content='<h1><i><font color=#5991A7><b><center>Data for </font><font color=#e68a00>$service</font> <font color=#5991A7> with</font> </font><font color=#e68a00>$interval</font> <font color=#5991A7>resolution</center></b></font></i></h1><br>',
    mode='html',
  ),
  gridPos={
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 0,
      },
  style=null,
)//30 text
.addPanel(
  singlestat.new(
    'Connected',//title
    description='Reports whether PMM Server can connect to the PostgreSQL instance.',
    format='none',
    datasource='Prometheus',
    valueName='avg',
    colorValue=true,
    thresholds='0,1',
    sparklineShow=true,
    colors=[
      '#d44a3a',
      'rgba(237, 129, 40, 0.89)',
      '#299c46',
    ],
    valueMaps=[
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        },
        {
          "op": "=",
          "text": "NO",
          "value": "0"
        },
        {
          "op": "=",
          "text": "YES",
          "value": "1"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'pg_up{service_name=~"$service"}',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
    "h": 2,
    "w": 2,
    "x": 0,
    "y": 2,
  },
  style=null,
)//63 singlestat
.addPanel(
  text.new(
    content='<h1><b><font color=#e68a00><center>$version</center></font></b></h1>',
    description='The version of the PostgreSQL instance.',
    mode='html',
    title='Version',
  ),
  gridPos={
        "h": 2,
        "w": 2,
        "x": 2,
        "y": 2,
      },
  style=null,
)//65 text
.addPanel(
  singlestat.new(
    'Max Connections',//title
    description='The maximum number of client connections allowed.  Change this value with care as there are some memory resources that are allocated on a per-client basis, so setting max_connections higher will generally increase overall PostgreSQL memory usage.',
    format='short',
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colors=[
      "#299c46",
      "rgba(237, 129, 40, 0.89)",
      "#d44a3a",
    ],
    links=[
        {
          "targetBlank": true,
          "title": "GUC-MAX-CONNECTIONS",
          "type": "absolute",
          "url": "https://www.postgresql.org/docs/current/static/runtime-config-connection.html#GUC-MAX-CONNECTIONS"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'max_over_time(pg_settings_max_connections{service_name=~"$service"}[$interval]) or
      max_over_time(pg_settings_max_connections{service_name=~"$service"}[5m])',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
        "h": 2,
        "w": 3,
        "x": 4,
        "y": 2,
  },
  style=null,
)//86 singlestat
.addPanel(
  singlestat.new(
    'Shared Buffers',//title
    description="Defines the amount of memory the database server uses for shared memory buffers.  Default is 128MB.  Guidance on tuning is 25% of RAM, but generally doesn't exceed 40%.",
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    decimals=2,
    links=[
        {
          "targetBlank": true,
          "title": "GUC-SHARED-BUFFERS",
          "type": "absolute",
          "url": "https://www.postgresql.org/docs/current/static/runtime-config-resource.html#GUC-SHARED-BUFFERS"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'max_over_time(pg_settings_shared_buffers_bytes{service_name=~"$service"}[$interval]) or
      max_over_time(pg_settings_shared_buffers_bytes{service_name=~"$service"}[5m]) ',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
    "h": 2,
    "w": 4,
    "x": 7,
    "y": 2
  },
  style=null,
)//67 singlestat
.addPanel(
  singlestat.new(
    'Disk-Page Buffers',//title
    description='The setting wal_buffers defines how much memory is used for caching the write-ahead log entries. Generally this value is small (3% of shared_buffers value), but it may need to be modified for heavily loaded servers.',
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    decimals=2,
    links=[
        {
          "title": "GUC-WAL-BUFFERS",
          "type": "absolute",
          "url": "https://www.postgresql.org/docs/current/static/runtime-config-wal.html#GUC-WAL-BUFFERS"
        },
        {
          "targetBlank": true,
          "title": "GUC-SHARED-BUFFERS",
          "type": "absolute",
          "url": "https://www.postgresql.org/docs/current/static/runtime-config-resource.html#GUC-SHARED-BUFFERS"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'max_over_time(pg_settings_wal_buffers_bytes{service_name=~"$service"}[$interval]) or
      max_over_time(pg_settings_wal_buffers_bytes{service_name=~"$service"}[5m])',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
    "h": 2,
    "w": 4,
    "x": 11,
    "y": 2
  },
  style=null,
)//68 singlestat
.addPanel(
  singlestat.new(
    'Memory Size for each Sort',//title
    description='The parameter work_mem defines the amount of memory assigned for internal sort operations and hash tables before writing to temporary disk files.  The default is 4MB.',
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    decimals=2,
    links=[
        {
          "dashboard": "https://www.postgresql.org/docs/current/static/runtime-config-resource.html#GUC-WORK-MEM",
          "targetBlank": true,
          "title": "GUC-WORK-MEM",
          "type": "absolute",
          "url": "https://www.postgresql.org/docs/current/static/runtime-config-resource.html#GUC-WORK-MEM"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'max_over_time(pg_settings_work_mem_bytes{service_name=~"$service"}[$interval]) or
      max_over_time(pg_settings_work_mem_bytes{service_name=~"$service"}[5m])',
      intervalFactor = 1,
    )
  ),
  gridPos = {
    "h": 2,
    "w": 4,
    "x": 15,
    "y": 2
  },
  style=null,
)//69 singlestat
.addPanel(
  singlestat.new(
    'Disk Cache Size',//title
    description="PostgreSQL's effective_cache_size variable tunes how much RAM you expect to be available for disk caching.  Generally adding Linux free+cached will give you a good idea.  This value is used by the query planner whether plans will fit in memory, and when defined too low, can lead to some plans rejecting certain indexes.",
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    decimals=2,
    links=[
        {
          "targetBlank": true,
          "title": "GUC-EFFECTIVE-CACHE-SIZE",
          "type": "absolute",
          "url": "https://www.postgresql.org/docs/current/static/runtime-config-query.html#GUC-EFFECTIVE-CACHE-SIZE"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'max_over_time(pg_settings_effective_cache_size_bytes{service_name=~"$service"}[$interval]) or
      max_over_time(pg_settings_effective_cache_size_bytes{service_name=~"$service"}[5m])',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
      "h": 2,
        "w": 3,
        "x": 19,
        "y": 2,
  },
  style=null,
)//70 singlestat
.addPanel(
  singlestat.new(
    'Autovacuum',//title
    description='Whether autovacuum process is enabled or not.  Generally the solution is to vacuum more often, not less.',
    colorValue=true,
    format='none',
    datasource='Prometheus',
    valueName='current',
    sparklineShow=true,
    thresholds='0,1',
    valueMaps=[
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        },
        {
          "op": "=",
          "text": "NO",
          "value": "0"
        },
        {
          "op": "=",
          "text": "YES",
          "value": "1"
        }
      ],
    colors=[
        "#d44a3a",
        "rgba(237, 129, 40, 0.89)",
        "#299c46"
      ],
    links=[
      {
        "targetBlank": true,
        "title": "AUTOVACUUM",
        "type": "absolute",
        "url": "https://www.postgresql.org/docs/current/static/routine-vacuuming.html#AUTOVACUUM"
      }
      ],
  )
  .addTarget(
    prometheus.target(
      'max_over_time(pg_settings_autovacuum{service_name=~"$service"}[$interval]) or
      max_over_time(pg_settings_autovacuum{service_name=~"$service"}[5m])',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
    "h": 2,
    "w": 2,
    "x": 22,
    "y": 2,
  },
  style=null,
)//85 singlestat
.addPanel(
    row.new(
      title='Connections',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 4,
    },
    style=null,
)//74 row
.addPanel(
  graphPanel.new(
    'PostgreSQL Connections',//title
    fill=2,
    decimals=0,
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
    decimalsY1=0,
    minY1='0',
    aliasColors={
        "Total ": "#bf1b00"
      },
  )
  .addSeriesOverride(
      {
          "alias": "Total",
          "color": "#bf1b00",
          "fill": 0
        }
  )
  .addTarget(
      prometheus.target(
        'sum(max_over_time(pg_stat_activity_count{service_name=~"$service",datname=~"$db"}[$interval]) or
        max_over_time(pg_stat_activity_count{service_name=~"$service",datname=~"$db"}[5m])) by (state)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{state}}',
      )
  )
  .addTarget(
      prometheus.target(
        'sum(max_over_time(pg_stat_activity_count{service_name=~"$service",datname=~"$db"}[$interval]) or
        max_over_time(pg_stat_activity_count{service_name=~"$service",datname=~"$db"}[5m]))',
        interval='$interval',
        legendFormat='Total',
        intervalFactor=1,
        metric='pg',
        step=2,
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 0,
    "y": 5,
  },
  style=null,
)//23 graph
.addPanel(
  graphPanel.new(
    'Active Connections',//title
    fill=2,
    decimals=0,
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
    stack=true,
    logBase1Y=2,
    decimalsY1=0,
    aliasColors={
        "Maximum commections": "#bf1b00"
      },
  )
  .addSeriesOverride(
    {
      "alias": "Maximum connections",
      "color": "#bf1b00",
      "fill": 0,
      "stack": false
    }
  )
  .addTarget(
      prometheus.target(
        'max_over_time(pg_stat_activity_count{instance="$host",datname=~"$db",state="active"}[$interval]) or
        max_over_time(pg_stat_activity_count{instance="$host",datname=~"$db",state="active"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{datname}}',
      )
  )
  .addTarget(
      prometheus.target(
        'max_over_time(pg_settings_max_connections{service_name=~"$service"}[$interval]) or
        max_over_time(pg_settings_max_connections{service_name=~"$service"}[5m])',
        interval='$interval',
        legendFormat='Maximum connections',
        intervalFactor=1,
      )
  ),
  gridPos={
      "h": 8,
      "w": 12,
      "x": 12,
      "y": 5,
  },
  style=null,
)//34 graph
.addPanel(
    row.new(
      title='Tuples',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 13,
    },
    style=null,
)//76 row
.addPanel(
  graphPanel.new(
    'Tuples',//title
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
    minY1='0',
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_tup_fetched{datname=~"$db",instance=~"$host"}[$interval])) or
        sum(irate(pg_stat_database_tup_fetched{datname=~"$db",instance=~"$host"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Fetched',
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_tup_returned{datname=~"$db",service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_tup_returned{datname=~"$db",service_name=~"$service"}[5m]))',
        interval='$interval',
        legendFormat='Returned',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_tup_inserted{datname=~"$db",service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_tup_inserted{datname=~"$db",service_name=~"$service"}[5m]))',
        interval='$interval',
        legendFormat='Inserted',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_tup_updated{datname=~"$db",service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_tup_updated{datname=~"$db",service_name=~"$service"}[5m]))',
        interval='$interval',
        legendFormat='Updated',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_tup_deleted{datname=~"$db",service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_tup_deleted{datname=~"$db",service_name=~"$service"}[5m]))',
        interval='$interval',
        legendFormat='Deleted',
        intervalFactor=1,
      )
  ),
  gridPos={
      "h": 8,
      "w": 12,
      "x": 0,
      "y": 14,
  },
  style=null,
)//36 graph
.addPanel(
  graphPanel.new(
    'Read Tuple Activity',//title
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
    legend_sort='avg',
    legend_sortDesc=true,
    formatY1='ops',
    minY1='0',
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_tup_returned{service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_tup_returned{service_name=~"$service"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Rows returned by queries',
        step=2,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_tup_fetched{service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_tup_fetched{service_name=~"$service"}[5m]))',
        interval='$interval',
        legendFormat='Rows fetched by queries',
        intervalFactor=1,
        step=2,
      )
  ),
  gridPos={
      "h": 8,
      "w": 12,
      "x": 12,
      "y": 14,
  },
  style=null,
)//24 graph
.addPanel(
  graphPanel.new(
    'Tuples Changed per $interval',//title
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
    legend_sort='avg',
    legend_sortDesc=true,
    formatY1='ops',
    minY1='0',
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_tup_inserted{service_name=~"$service"}[1m])) or
        sum(irate(pg_stat_database_tup_inserted{service_name=~"$service"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Rows inserted by queries',
        metric='pg_stat_database_tup',
        step=2,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_tup_updated{service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_tup_updated{service_name=~"$service"}[5m]))',
        interval='$interval',
        legendFormat='Rows updated by queries',
        intervalFactor=1,
        metric='pg_stat_database_tup',
        step=2,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_tup_deleted{service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_tup_deleted{service_name=~"$service"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Rows deleted by queries',
        metric='pg_stat_database_tup',
        step=2,
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 0,
    "y": 22,
  },
  style=null,
)//25 graph
.addPanel(
    row.new(
      title='Transactions',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 30,
    },
    style=null,
)//78 row
.addPanel(
  graphPanel.new(
    'Transactions',//title
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
    legend_sort='avg',
    legend_sortDesc=true,
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_xact_commit{service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_xact_commit{service_name=~"$service"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Commits',
        metric='pg_stat_database_xact_commit',
        step=2,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_xact_rollback{service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_xact_rollback{service_name=~"$service"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Rollbacks',
        metric='pg_stat_database_xact_commit',
        step=2,
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 0,
    "y": 31,
  },
  style=null,
)//26 graph
.addPanel(
  graphPanel.new(
    'Duration of Transactions',//title
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
    legend_sort='avg',
    legend_sortDesc=true,
    format='s',
    minY1='0',
  )
  .addTarget(
      prometheus.target(
        'max_over_time(pg_stat_activity_max_tx_duration{service_name=~"$service"}[$interval]) or
        max_over_time(pg_stat_activity_max_tx_duration{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{state}}',
        metric='pg_stat_activity_max_tx_duration',
        step=2,
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 12,
    "y": 31,
  },
  style=null,
)//18 graph
.addPanel(
    row.new(
      title='Temp Files',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 39,
    },
    style=null,
)//80 row
.addPanel(
  graphPanel.new(
    'Number of Temp Files',//title
    fill=1,
    decimals=0,
    linewidth=1,
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
    decimalsY1=0,
    minY1='0',
  )
  .addTarget(
      prometheus.target(
        'max_over_time(pg_stat_database_temp_files{service_name=~"$service",datname!~"template.*"}[$interval]) or
        max_over_time(pg_stat_database_temp_files{service_name=~"$service",datname!~"template.*"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{datname}}',
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 0,
    "y": 40,
  },
  style=null,
)//48 graph
.addPanel(
  graphPanel.new(
    'Size of Temp Files',//title
    fill=1,
    decimals=2,
    linewidth=1,
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
    decimalsY1=2,
    formatY1='bytes',
    minY1='0',
  )
  .addSeriesOverride(
      {
          "alias": "increase *",
          "bars": true,
          "lines": false
        }
  )
  .addTarget(
      prometheus.target(
        'max_over_time(pg_stat_database_temp_bytes{service_name=~"$service",datname!~"template.*"}[$interval]) or
        max_over_time(pg_stat_database_temp_bytes{service_name=~"$service",datname!~"template.*"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{datname}}',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(pg_stat_database_temp_bytes{service_name=~"$service",datname!~"template.*"}[$interval]) or
        irate(pg_stat_database_temp_bytes{service_name=~"$service",datname!~"template.*"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='increase {{datname}}',
        hide=true,
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 12,
    "y": 40,
  },
  style=null,
)//49 graph
.addPanel(
    row.new(
      title='Conflicts & Locks',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 48,
    },
    style=null,
)//82 row
.addPanel(
  graphPanel.new(
    'Conflicts/Deadlocks',//title
    fill=1,
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
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    nullPointMode='connected',
    value_type='cumulative',
    minY1='0',
    formatY1='ops',
  )
  .addTarget(
      prometheus.custom(
          alias='conflicts',
          dsType='prometheus',
          expr='sum(rate(pg_stat_database_deadlocks{datname=~"$db",service_name=~"$service"}[$interval])) or
          sum(irate(pg_stat_database_deadlocks{datname=~"$db",service_name=~"$service"}[5m]))',
          format='time_series',
          groupBy=[
            {
              "params": [
                "$interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
            ],
          interval='$interval',
          intervalFactor=1,
          legendFormat='Deadlocks',
          measurement='postgresql',
          policy='default',
          refId='A',
          resultFormat='time_series',
          select=[
            [
              {
                "params": [
                  "conflicts"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [],
                "type": "difference"
              }
            ]
            ],
          step=2,
          tags=[
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$host$/"
            }
            ],
      )
  )
  .addTarget(
      prometheus.custom(
          alias='deadlocks',
          dsType='prometheus',
          expr='sum(rate(pg_stat_database_conflicts{datname=~"$db",service_name=~"$service"}[$interval])) or
          sum(irate(pg_stat_database_conflicts{datname=~"$db",service_name=~"$service"}[5m]))',
          format='time_series',
          groupBy=[
            {
              "params": [
                "$interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
            ],
          interval='$interval',
          intervalFactor=1,
          legendFormat='Conflicts',
          measurement='postgresql',
          policy='default',
          refId='B',
          resultFormat='time_series',
          select=[
            [
              {
                "params": [
                  "deadlocks"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [],
                "type": "difference"
              }
            ]
            ],
          step=2,
          tags=[
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$host$/"
            }
            ],
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 0,
    "y": 49,
  },
  style=null,
)//3 graph
.addPanel(
  graphPanel.new(
    'Number of Locks',//title
    fill=2,
    decimals=0,
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
    nullPointMode='connected',
    value_type='cumulative',
    minY1='0',
    decimalsY1=0,
  )
  .addTarget(
      prometheus.custom(
          alias='conflicts',
          dsType='prometheus',
          expr='max_over_time(pg_locks_count{datname=~"$db",service_name=~"$service",datname!~"template.*"}[$interval]) or
          max_over_time(pg_locks_count{datname=~"$db",service_name=~"$service",datname!~"template.*"}[5m])',
          format='time_series',
          groupBy=[
            {
              "params": [
                "$interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
            ],
          interval='$interval',
          intervalFactor=1,
          legendFormat='{{mode}} - {{datname}}',
          measurement='postgresql',
          policy='default',
          refId='A',
          resultFormat='time_series',
          select=[
            [
              {
                "params": [
                  "conflicts"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [],
                "type": "difference"
              }
            ]
            ],
          step=2,
          tags=[
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$host$/"
            }
            ],
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 12,
    "y": 49,
  },
  style=null,
)//61 graph
.addPanel(
    row.new(
      title='Buffers & Blocks Operations',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 57,
    },
    style=null,
)//84 row
.addPanel(
  graphPanel.new(
    'Operations with Blocks',//title
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
    legend_sort='avg',
    legend_sortDesc=true,
    formatY1='rps',
    decimalsY1=0,
    formatY2='wps',
    decimalsY2=0,
    min='0',
  )
  .addSeriesOverride(
        {
          "alias": "/Write */",
          "yaxis": 2
        }
  )
  .addTarget(
      prometheus.target(
        'rate(pg_stat_database_blk_read_time{datname=~"$db",service_name=~"$service",datname!~"template.*|postgres"}[$interval]) or
        irate(pg_stat_database_blk_read_time{datname=~"$db",service_name=~"$service",datname!~"template.*|postgres"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Read {{datname}}',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(pg_stat_database_blk_write_time{datname=~"$db",service_name=~"$service",datname!~"template.*|postgres"}[$interval]) or
        irate(pg_stat_database_blk_write_time{datname=~"$db",service_name=~"$service",datname!~"template.*|postgres"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Write {{datname}}',
      )
  ),
  gridPos={
    "h": 8,
     "w": 12,
     "x": 0,
     "y": 58,
  },
  style=null,
)//50 graph
.addPanel(
  graphPanel.new(
    'Buffers',//title
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
    legend_sort='avg',
    legend_sortDesc=true,
    nullPointMode='connected',
    value_type='cumulative',
    minY1=0,
  )
  .addTarget(
      prometheus.custom(
          alias='Buffers Allocated',
          dsType='prometheus',
          expr='rate(pg_stat_bgwriter_buffers_alloc{service_name=~"$service"}[$interval]) or
          irate(pg_stat_bgwriter_buffers_alloc{service_name=~"$service"}[5m])',
          format='time_series',
          groupBy=[
            {
              "params": [
                "$interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
            ],
          interval='$interval',
          intervalFactor=1,
          legendFormat='Allocated',
          measurement='postgresql',
          policy='default',
          refId='A',
          resultFormat='time_series',
          select=[
            [
              {
                "params": [
                  "buffers_alloc"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [],
                "type": "difference"
              }
            ]
            ],
          step=2,
          tags=[
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$host$/"
            }
            ],
      )
  )
  .addTarget(
      prometheus.custom(
          alias='Buffers Allocated',
          dsType='prometheus',
          expr='rate(pg_stat_bgwriter_buffers_backend_fsync{service_name=~"$service"}[$interval]) or
          irate(pg_stat_bgwriter_buffers_backend_fsync{service_name=~"$service"}[5m])',
          format='time_series',
          groupBy=[
            {
              "params": [
                "$interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
            ],
          interval='$interval',
          intervalFactor=1,
          legendFormat='Fsync calls by a backend',
          measurement='postgresql',
          policy='default',
          refId='B',
          resultFormat='time_series',
          select=[
            [
              {
                "params": [
                  "buffers_alloc"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [],
                "type": "difference"
              }
            ]
            ],
          step=2,
          tags=[
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$host$/"
            }
            ],
      )
  )
  .addTarget(
      prometheus.custom(
          alias='Buffers Allocated',
          dsType='prometheus',
          expr='rate(pg_stat_bgwriter_buffers_backend{service_name=~"$service"}[$interval]) or
          irate(pg_stat_bgwriter_buffers_backend{service_name=~"$service"}[5m])',
          format='time_series',
          groupBy=[
            {
              "params": [
                "$interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
            ],
          interval='$interval',
          intervalFactor=1,
          legendFormat='Written directly by a backend',
          measurement='postgresql',
          policy='default',
          refId='C',
          resultFormat='time_series',
          select=[
            [
              {
                "params": [
                  "buffers_alloc"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [],
                "type": "difference"
              }
            ]
            ],
          step=2,
          tags=[
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$host$/"
            }
            ],
      )
  )
  .addTarget(
      prometheus.custom(
          alias='Buffers Allocated',
          dsType='prometheus',
          expr='rate(pg_stat_bgwriter_buffers_clean{service_name=~"$service"}[$interval]) or
          irate(pg_stat_bgwriter_buffers_clean{service_name=~"$service"}[5m])',
          format='time_series',
          groupBy=[
            {
              "params": [
                "$interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
            ],
          interval='$interval',
          intervalFactor=1,
          legendFormat='Written by the background writer',
          measurement='postgresql',
          policy='default',
          refId='D',
          resultFormat='time_series',
          select=[
            [
              {
                "params": [
                  "buffers_alloc"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [],
                "type": "difference"
              }
            ]
            ],
          step=2,
          tags=[
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$host$/"
            }
            ],
      )
  )
  .addTarget(
      prometheus.custom(
          alias='Buffers Allocated',
          dsType='prometheus',
          expr='rate(pg_stat_bgwriter_buffers_checkpoint{service_name=~"$service"}[5m]) or
          irate(pg_stat_bgwriter_buffers_checkpoint{service_name=~"$service"}[5m])',
          format='time_series',
          groupBy=[
            {
              "params": [
                "$interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
            ],
          interval='$interval',
          intervalFactor=1,
          legendFormat='Written during checkpoints',
          measurement='postgresql',
          policy='default',
          refId='E',
          resultFormat='time_series',
          select=[
            [
              {
                "params": [
                  "buffers_alloc"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [],
                "type": "difference"
              }
            ]
            ],
          step=2,
          tags=[
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$host$/"
            }
            ],
      )
  ),
  gridPos={
    "h": 8,
     "w": 12,
     "x": 12,
     "y": 58,
  },
  style=null,
)//2 graph
.addPanel(
    row.new(
      title='Others',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 66,
    },
    style=null,
)//72 row
.addPanel(
  graphPanel.new(
    'Canceled Queries',//title
    description='Based on pg_stat_database_conflicts view',
    fill=2,
    decimals=0,
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
    minY1='0',
    formatY1='ops',
    decimalsY1=0,
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_conflicts_confl_bufferpin{service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_conflicts_confl_bufferpin{service_name=~"$service"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Pinned buffers',
        metric='pg_stat_database_conflicts_confl_bufferpin',
        step=2,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_conflicts_confl_deadlock{service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_conflicts_confl_deadlock{service_name=~"$service"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Deadlocks',
        metric='pg_stat_database_conflicts_confl_bufferpin',
        step=2,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_conflicts_confl_lock{service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_conflicts_confl_lock{service_name=~"$service"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Lock timeouts',
        metric='pg_stat_database_conflicts_confl_bufferpin',
        step=2,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_conflicts_confl_snapshot{service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_conflicts_confl_snapshot{service_name=~"$service"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Old snapshots',
        metric='pg_stat_database_conflicts_confl_bufferpin',
        step=2,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(pg_stat_database_conflicts_confl_tablespace{service_name=~"$service"}[$interval])) or
        sum(irate(pg_stat_database_conflicts_confl_tablespace{service_name=~"$service"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Dropped tablespaces ',
        metric='pg_stat_database_conflicts_confl_bufferpin',
        step=2,
      )
  ),
  gridPos={
      "h": 8,
      "w": 12,
      "x": 0,
      "y": 67,
  },
  style=null,
)//28 graph
.addPanel(
  graphPanel.new(
    'Cache Hit Ratio',//title
    fill=2,
    decimals=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=1,
    percentage=true,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    value_type='cumulative',
    nullPointMode='connected',
    maxPerRow=6,
    minY1='0',
    maxY1='1',
    formatY1='percentunit',
    formatY2='percent',
  )
  .addTarget(
      prometheus.target(
        'sum(pg_stat_database_blks_hit{datname=~"$db",service_name=~"$service",datname!~"template.*"}) by (datname) /
        (sum(pg_stat_database_blks_hit{datname=~"$db",service_name=~"$service",datname!~"template.*"}) by (datname) +
        sum(pg_stat_database_blks_read{datname=~"$db",service_name=~"$service",datname!~"template.*"}) by (datname))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Cache hit rate {{datname}}',
      )
  ),
  gridPos={
      "h": 8,
      "w": 12,
      "x": 12,
      "y": 67,
  },
  style=null,
)//14 graph
.addPanel(
  graphPanel.new(
    'Checkpoint stats',//title
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
    minY1='0',
    formatY1='ops',
    formatY2='ms',
  )
  .addTarget(
      prometheus.target(
        'rate(pg_stat_bgwriter_checkpoint_sync_time{service_name=~"$service"}[$interval]) or
        irate(pg_stat_bgwriter_checkpoint_sync_time{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Files Synchronization to disk',
        metric='pg_stat_bgwriter_checkpoint_sync_time',
        step=2,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(pg_stat_bgwriter_checkpoint_write_time{service_name=~"$service"}[$interval]) or
        irate(pg_stat_bgwriter_checkpoint_write_time{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Written Files to disk',
        metric='pg_stat_bgwriter_checkpoint_write_time',
        step=2,
      )
  ),
  gridPos={
      "h": 8,
      "w": 12,
      "x": 0,
      "y": 75,
  },
  style=null,
)//22 graph
.addPanel(
    row.new(
      title='Settings',
      collapse=true,
    )
    .addPanel(
      text.new(
        content="<table style=\"width:100%; border: 2px solid grey;\">\n  <tr><td></td><td></td><td></td><td></td></tr>\n  <tr><td> The maximum number of concurrent connections </td><td>${max_connections}</td><td> Shared memory buffers (bytes) </td><td>${shared_buffers}</td></tr>\n  <tr><td> The maximum memory to be used for query workspaces (bytes)</td><td>${work_mem}</td><td> The number of disk-page buffers in shared memory for WAL (bytes)</td><td>${wal_buffers}</td></tr>\n  <tr><td> The number of pages per write ahead log segment (bytes) </td><td>${wal_segment_size}</td><td>The maximum memory to be used for query workspaces (bytes)</td><td>${maintenance_work_mem}</td></tr>\n  <tr><td> The block size in the write ahead log </td><td>${block_size}</td><td>The maximum distance in log segments between automatic WAL checkpoints</td><td>${checkpoint_segments}</td></tr>\n  <tr><td> Time spent flushing dirty buffers during checkpoint, as fraction of checkpoint interval </td><td>${checkpoint_timeout}</td><td>The maximum number of simultaneously running WAL sender processes</td><td>${max_wal_senders}</td></tr>\n  <tr><td> The minimum size to shrink the WAL to (bytes)</td><td>${min_wal_size}</td><td>The WAL size that triggers a checkpoint (bytes)</td><td>${max_wal_size}</td></tr>\n  <tr><td> Compresses full-page writes written in WAL file </td><td>${wal_compression}</td><td>Maximum number of concurrent worker processes</td><td>${max_worker_processes}</td></tr>\n  <tr><td> The maximum number of parallel processes per executor node </td><td>${max_parallel_workers_per_gather}</td><td>The maximum number of parallel processes per executor node</td><td>${max_parallel_workers}</td></tr>\n  <tr><td> The default statistics target </td><td>${default_statistics_target}</td><td>The planner's estimate of the cost of a sequentially fetched disk page </td><td>${seq_page_cost}</td></tr>\n  <tr><td> The planner's estimate of the cost of a nonsequentially fetched disk page </td><td>${random_page_cost}</td><td>The planner's assumption about the size of the disk cache</td><td>${effective_cache_size}</td></tr>\n  <tr><td> Number of simultaneous requests that can be handled efficiently by the disk subsystem </td><td>${effective_io_concurrency}</td><td>Forces synchronization of updates to disk </td><td>${fsync}</td></tr>\n  <tr><td> Starts the autovacuum subprocess </td><td>${autovacuum}</td><td>Number of tuple inserts, updates, or deletes prior to analyze as a fraction of reltuples</td><td>${autovacuum_analyze_scale_factor}</td></tr>\n  <tr><td> Minimum number of tuple inserts, updates, or deletes prior to analyze </td><td>${autovacuum_analyze_threshold}</td><td>Number of tuple updates or deletes prior to vacuum as a fraction of reltuples</td><td>${autovacuum_vacuum_scale_factor}</td></tr>\n  <tr><td> Minimum number of tuple updates or deletes prior to vacuum </td><td>${autovacuum_vacuum_threshold}</td><td>Vacuum cost amount available before napping, for autovacuum </td><td>${autovacuum_vacuum_cost_limit}</td></tr>\n  <tr><td> Vacuum cost delay in milliseconds, for autovacuum (seconds) </td><td>${autovacuum_vacuum_cost_delay}</td><td> The maximum number of simultaneously running autovacuum worker processes </td><td>${autovacuum_max_workers}</td></tr>\n  <tr><td> Time to sleep between autovacuum runs (seconds) </td><td>${autovacuum_naptime}</td><td>Age at which to autovacuum a table to prevent transaction ID wraparound </td><td>${autovacuum_freeze_max_age}</td></tr>\n  <tr><td> The maximum memory to be used by each autovacuum worker process (bytes)</td><td>${autovacuum_work_mem}</td><td>Multixact age at which to autovacuum a table to prevent multixact wraparound</td><td>${autovacuum_multixact_freeze_max_age}</td></tr>\n  <tr><td> Start a subprocess to capture stderr output and/or csvlogs into log files </td><td>${logging_collector}</td><td>Sets the minimum execution time above which statements will be logged (seconds) </td><td>${log_min_duration_statement}</td></tr>\n  <tr><td> Logs the duration of each completed SQL statement </td><td>${log_duration}</td><td>Logs long lock waits </td><td>${log_lock_waits}</td></tr>\n  <tr><td></td><td></td><td></td><td></td></tr>\n</table>\n\n",
        mode='html',
        title='PostgreSQL Settings',
      ),
      gridPos={
        "h": 18,
        "w": 24,
        "x": 0,
        "y": 84,
          },
    )//58 text
    ,gridPos={
      "h": 1,
       "w": 24,
       "x": 0,
       "y": 83,
    },
    style=null,
)//60 row
.addPanel(
    row.new(
      title='System Summary',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'CPU Usage',//title
        fill=5,
        decimals=2,
        linewidth=1,
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
        legend_hideEmpty=true,
        legend_hideZero=true,
        minY1='0',
        maxY1='100',
        formatY1='percent',
      )
      .addTarget(
          prometheus.target(
            'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~"$host",mode!="idle"}[$interval]),1)) or
            (clamp_max(irate(node_cpu_seconds_total{node_name=~"$host",mode!="idle"}[5m]),1)) ))*100 or (avg_over_time(node_cpu_average{node_name=~"$host", mode!="total", mode!="idle"}[$interval]) or
            avg_over_time(node_cpu_average{node_name=~"$host", mode!="total", mode!="idle"}[5m]))),100)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{mode}}',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 85,
      }
    )//90 graph
    .addPanel(
      graphPanel.new(
        'Saturation and Max Core Usage',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        min='0',
        maxY2='1',
        formatY2='percentunit',
      )
      .addSeriesOverride({
              "alias": "Max CPU Core Utilization",
              "lines": false,
              "pointradius": 1,
              "points": true,
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            '(avg_over_time(node_procs_running{node_name=~"$service"}[$interval])-1) / scalar(count(node_cpu_seconds_total{mode="user", node_name=~"$service"})) or (avg_over_time(node_procs_running{node_name=~"$host"}[5m])-1) / scalar(count(node_cpu_seconds_total{mode="user", node_name=~"$host"}))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Normalized CPU Load',
          )
      )
      .addTarget(
          prometheus.target(
            'clamp_max(max by () (sum  by (cpu) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~"$host",mode!="idle",mode!="iowait"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~"$host",mode!="idle",mode!="iowait"}[5m]),1)) )),1)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Max CPU Core Utilization',
          )
      )
      .addTarget(
          prometheus.target(
            'avg_over_time(node_procs_blocked{node_name=~"$host"}[$interval]) or avg_over_time(node_procs_blocked{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='IO Load',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 85,
      }
    )//92 graph
    .addPanel(
      graphPanel.new(
        'Disk I/O and Swap Activity',//title
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
        formatY1='Bps',
        labelY1='Page Out (-) / Page In (+)',
      )
      .addSeriesOverride({
              "alias": "Disk Writes (Page Out)",
              "transform": "negative-Y"
            })
      .addSeriesOverride({
              "alias": "Total",
              "legend": false,
              "lines": false
            })
      .addSeriesOverride({
              "alias": "Swap Out (Writes)",
              "transform": "negative-Y"
            })
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgpgin{node_name=~"$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgin{node_name=~"$host"}[5m]) * 1024',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Disk Reads (Page In)',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(node_vmstat_pgpgout{node_name=~"$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgout{node_name=~"$host"}[5m]) * 1024)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Disk Writes (Page Out)',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(node_vmstat_pgpgin{node_name=~"$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgin{node_name=~"$hostt"}[5m]) * 1024 ) +
            (rate(node_vmstat_pgpgout{node_name=~"$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgout{node_name=~"$host"}[5m]) * 1024)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pswpin{node_name=~"$host"}[$interval]) * 4096 or irate(node_vmstat_pswpin{node_name=~"$host"}[5m]) * 4096',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Swap In (Reads)',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pswpout{node_name=~"$host"}[$interval]) * 4096 or
            irate(node_vmstat_pswpout{node_name=~"$host"}[5m]) * 4096',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Swap Out (Writes)',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 93,
      }
    )//94 graph
    .addPanel(
      graphPanel.new(
        'Network Traffic',//title
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
        formatY1='Bps',
        labelY1='Outbound (-) / Inbound (+)',
      )
      .addSeriesOverride({
              "alias": "Outbound",
              "transform": "negative-Y"
            })
      .addTarget(
          prometheus.target(
            'sum(rate(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[$interval])) or
            sum(irate(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[5m])) or
            sum(max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[$interval])) or
            sum(max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[5m])) ',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Inbound',
          )
      )
      .addTarget(
          prometheus.target(
            'sum(rate(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[$interval])) or sum(irate(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[5m])) or
            sum(max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[$interval])) or sum(max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Outbound',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 93,
      }
    )//96 graph
    ,gridPos={
      "h": 1,
       "w": 24,
       "x": 0,
       "y": 84,
    },
    style=null,
)//88 row
