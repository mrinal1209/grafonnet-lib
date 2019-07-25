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
local pmmSinglestat = grafana.pmmSinglestat;


dashboard.new(
  'MongoDB Cluster Summary',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=16,
  version=1,
  tags=['MongoDB','Percona'],
  iteration=1529322310813,
  uid="n9z9QGNiz",
  timepicker = timepicker.new(
    hidden = false,
    now= true,
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
  includeAll=false,
  )
)
.addPanel(
  singlestat.new(
    'Unsharded DBs',//title
    colorValue=false,
    format='none',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    thresholds='',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    timeFrom='1m',
    editable=true,
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'max(mongodb_mongos_sharding_databases_total{cluster="$cluster", type="unpartitioned"})',
      intervalFactor = 1,
      interval='5m',
      legendFormat='Shards',
      step=300,
    )
  ),
  gridPos = {
      "h": 3,
      "w": 6,
      "x": 0,
      "y": 0,
    },
  style=null,
)//39 singlestat
.addPanel(
  singlestat.new(
    'Sharded DBs',//title
    colorValue=false,
    format='none',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    thresholds='',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    timeFrom='1m',
    editable=true,
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'max(mongodb_mongos_sharding_databases_total{cluster="$cluster", type="partitioned"})',
      intervalFactor = 1,
      interval='5m',
      legendFormat='Shards',
      step=300,
    )
  ),
  gridPos = {
      "h": 3,
      "w": 6,
      "x": 6,
      "y": 0,
    },
  style=null,
)//35 singlestat
.addPanel(
  singlestat.new(
    'Sharded Collections',//title
    colorValue=false,
    format='none',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    thresholds='',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    timeFrom='1m',
    editable=true,
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'max(mongodb_mongos_sharding_collections_total{cluster="$cluster"})',
      intervalFactor = 1,
      interval='5m',
      legendFormat='Shards',
      step=300,
    )
  ),
  gridPos = {
      "h": 3,
      "w": 6,
      "x": 12,
      "y": 0,
    },
  style=null,
)//10 singlestat
.addPanel(
  singlestat.new(
    'Shards',//title
    colorValue=false,
    format='none',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    thresholds='',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    timeFrom='1m',
    editable=true,
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'max(mongodb_mongos_sharding_shards_total{cluster="$cluster"})',
      intervalFactor = 1,
      interval='5m',
      legendFormat='Shards',
      step=300,
    )
  ),
  gridPos = {
      "h": 3,
      "w": 6,
      "x": 18,
      "y": 0,
    },
  style=null,
)//36 singlestat
.addPanel(
  singlestat.new(
    'Chunks',//title
    colorValue=false,
    format='none',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    thresholds='',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    timeFrom='1m',
    editable=true,
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'max(mongodb_mongos_sharding_chunks_total{cluster="$cluster"})',
      intervalFactor = 1,
      interval='5m',
      legendFormat='Chunks',
      step=300,
    )
  ),
  gridPos = {
      "h": 3,
      "w": 6,
      "x": 0,
      "y": 3,
    },
  style=null,
)//11 singlestat
.addPanel(
  singlestat.new(
    'Balancer Enabled',//title
    colorValue=false,
    format='none',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    timeFrom='1m',
    editable=true,
    valueMaps=[
        {
          "op": "=",
          "text": "YES",
          "value": "1"
        },
        {
          "op": "=",
          "text": "NO",
          "value": "0"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'max(mongodb_mongos_sharding_balancer_enabled{cluster="$cluster"})',
      intervalFactor = 1,
      interval='5m',
      legendFormat='Cluster Balanced',
      step=300,
    )
  ),
  gridPos = {
      "h": 3,
      "w": 6,
      "x": 6,
      "y": 3,
    },
  style=null,
)//5 singlestat
.addPanel(
  singlestat.new(
    'Chunks Balanced',//title
    colorValue=false,
    format='none',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    thresholds='',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    timeFrom='1m',
    editable=true,
    valueMaps=[
        {
          "op": "=",
          "text": "YES",
          "value": "1"
        },
        {
          "op": "=",
          "text": "NO",
          "value": "0"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'min(mongodb_mongos_sharding_chunks_is_balanced{cluster="$cluster"})',
      intervalFactor = 1,
      interval='5m',
      legendFormat='Cluster Balanced',
      step=300,
    )
  ),
  gridPos = {
      "h": 3,
      "w": 6,
      "x": 12,
      "y": 3,
    },
  style=null,
)//4 singlestat
.addPanel(
  graphPanel.new(
    'Mongos Operations',//title
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideZero=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    value_type='cumulative',
    formatY1='ops',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongos_op_counters_total{cluster="$cluster", type!="command"}[$interval]) or irate(mongodb_mongos_op_counters_total{cluster="$cluster", type!="command"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{type}}',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
     "w": 24,
     "x": 0,
     "y": 6,
  },
  style=null,
)//46 graph
.addPanel(
  graphPanel.new(
    'Mongos  Connections',//title
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
  )
  .addTarget(
      prometheus.target(
        'sum(mongodb_mongos_connections{cluster="$cluster", state="current"})',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Connections',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 13,
  },
  style=null,
)//7 graph
.addPanel(
  graphPanel.new(
    'Mongos  Cursors',//title
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
  )
  .addTarget(
      prometheus.target(
        'sum(mongodb_mongos_metrics_cursor_open{cluster="$cluster", state="total"} or mongodb_mongos_cursors{cluster="$cluster", state="total_open"})',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Cursors',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 13,
  },
  style=null,
)//31 graph
.addPanel(
  graphPanel.new(
    'Chunk Split Events',//title
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
  )
  .addTarget(
      prometheus.target(
        'max(increase(mongodb_mongos_sharding_changelog_10min_total{cluster="$cluster", event=~".*split.*"}[$interval])) by (event)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{event}}',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 20,
  },
  style=null,
)//3 graph
.addPanel(
  graphPanel.new(
    'Change Log Events',//title
    fill=2,
    linewidth=2,
    decimals=0,
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
  )
  .addTarget(
      prometheus.target(
        'max(increase(mongodb_mongos_sharding_changelog_10min_total{cluster="$cluster", event=~".*(shard|Shard).*"}[$interval])) by (event)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{event}}',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 20,
  },
  style=null,
)//38 graph
.addPanel(
  graphPanel.new(
    'Operations Per Shard',//title
    fill=6,
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
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'sum(sum(rate(mongodb_mongod_op_counters_total{cluster="$cluster", type!="command"}[$interval]) or irate(mongodb_mongod_op_counters_total{cluster="$cluster", type!="command"}[5m])) by (instance) * on (instance) group_right mongodb_mongod_replset_my_state{cluster="$cluster"} / mongodb_mongod_replset_my_state{cluster="$cluster"}) by (set)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{set}}',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 27,
  },
  style=null,
)//30 graph
.addPanel(
  graphPanel.new(
    'Chunks by Shard',//title
    fill=6,
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
        'mongodb_mongos_sharding_shard_chunks_total{cluster="$cluster"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{shard}}',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 27,
  },
  style=null,
)//41 graph
.addPanel(
  graphPanel.new(
    'Connections Per Shard',//title
    fill=6,
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
  )
  .addTarget(
      prometheus.target(
        'sum(mongodb_mongod_connections{cluster="$cluster", state="current"} * on (instance) group_right mongodb_mongod_replset_my_state{cluster="$cluster"}/ mongodb_mongod_replset_my_state{cluster="$cluster"}) by (set)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{set}}',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 34,
  },
  style=null,
)//37 graph
.addPanel(
  graphPanel.new(
    'Cursors Per Shard',//title
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
    value_type='cumulative',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'sum(sum(mongodb_mongod_metrics_cursor_open{cluster="$cluster", state="total"} or mongodb_mongod_cursors{cluster="$cluster", state="total_open"}) by (instance) * on (instance) group_right mongodb_mongod_replset_my_state{cluster="$cluster"} / mongodb_mongod_replset_my_state{cluster="$cluster"}) by (set)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{set}}',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 34,
  },
  style=null,
)//25 graph
.addPanel(
  graphPanel.new(
    'Replication Lag by Set',//title
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
    value_type='cumulative',
    formatY1='s',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'max(mongodb_mongod_replset_member_optime_date{cluster="$cluster", state="PRIMARY"}) by (set) - min(mongodb_mongod_replset_member_optime_date{cluster="$cluster", state="SECONDARY"}) by (set)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{set}}',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 41,
  },
  style=null,
)//14 graph
.addPanel(
  graphPanel.new(
    'Oplog Range by Set',//title
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
    value_type='cumulative',
    formatY1='s',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'max(max(mongodb_mongod_replset_oplog_head_timestamp{cluster="$cluster"}-mongodb_mongod_replset_oplog_tail_timestamp{cluster="$cluster"}) by (instance) * on (instance) group_right mongodb_mongod_replset_my_state{cluster="$cluster"} / mongodb_mongod_replset_my_state{cluster="$cluster"}) by (set)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{set}}',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 41,
  },
  style=null,
)//27 graph
.addPanel(
  graphPanel.new(
    'Shard Elections',//title
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
    value_type='cumulative',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'max(changes(mongodb_mongod_replset_member_election_date{cluster="$cluster"}[$interval])) by (set)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{set}}',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 48,
  },
  style=null,
)//12 graph
.addPanel(
  graphPanel.new(
    'Collection Lock Time',//title
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
    value_type='cumulative',
    formatY1='µs',
    minY1=0,
  )
  .addTarget(
      prometheus.target(
        'max(max(mongodb_mongod_locks_time_locked_global_microseconds_total{cluster="$cluster", database="Collection"}) by (instance) * on (instance) group_right mongodb_mongod_replset_my_state{cluster="$cluster"} / mongodb_mongod_replset_my_state{cluster="$cluster"}) by (set)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{set}}',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 48,
  },
  style=null,
)//22 graph
