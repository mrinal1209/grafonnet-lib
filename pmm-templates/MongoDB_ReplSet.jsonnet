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
  'MongoDB ReplSet',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=16,
  version=1,
  tags=['Percona','MongoDB'],
  iteration=1553527716502,
  uid="7lzrQGNik",
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
  allFormat='blob',
  includeAll=true,
  ),
)
.addTemplate(
  template.new(
  'replset',
  'Prometheus',
  'label_values(mongodb_mongod_replset_my_state{cluster=~"$cluster"}, set)',
  label='Replica Set',
  refresh='load',
  sort=1,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  allFormat='glob',
  multiFormat='glob',
  ),
)
.addTemplate(
  template.new(
  'host',
  'Prometheus',
  'label_values(mongodb_mongod_replset_my_state{cluster=~"$cluster", set="$replset"}, node_name)',
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
  'label_values(mongodb_mongod_replset_my_state{cluster=~"$cluster",node_name=~"$host",set="$replset"}, service_name)',
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
    'ReplSet State',//title
    description='This shows the role of the selected instance. Normally this should be one of ``PRIMARY``, ``SECONDARY`` and ``ARBITER``, but if the system is newly added it could show ``STARTUP2`` during its initial sync.

Read more about [Replica Set Member States](https://docs.mongodb.com/manual/reference/replica-states/).',
    format='none',
    datasource='Prometheus',
    decimals=0,
    editable=true,
    thresholds='',
    height='125px',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
      ],
    valueMaps=[
        {
          "op": "=",
          "text": "PRIMARY",
          "value": "1"
        },
        {
          "op": "=",
          "text": "SECONDARY",
          "value": "2"
        },
        {
          "op": "=",
          "text": "STARTUP",
          "value": "0"
        },
        {
          "op": "=",
          "text": "RECOVERING",
          "value": "3"
        },
        {
          "op": "=",
          "text": "STARTUP2",
          "value": "5"
        },
        {
          "op": "=",
          "text": "UNKNOWN",
          "value": "6"
        },
        {
          "op": "=",
          "text": "ARBITER",
          "value": "7"
        },
        {
          "op": "=",
          "text": "DOWN",
          "value": "8"
        },
        {
          "op": "=",
          "text": "ROLLBACK",
          "value": "9"
        },
        {
          "op": "=",
          "text": "REMOVED",
          "value": "10"
        }
      ],
    valueName='current',
    timeFrom='1m',
  )
  .addTarget(
    prometheus.target(
      'mongodb_mongod_replset_my_state{service_name=~"$service"}',
      intervalFactor = 1,
      interval='5m',
      step=300,
    )
  ),
  gridPos = {},
  style=null,
)//49 singlestat
.addPanel(
  singlestat.new(
    'ReplSet Members',//title
    description='This shows how many members are configured in the replica set.',
    format='none',
    datasource='Prometheus',
    decimals=0,
    editable=true,
    thresholds='',
    height='125px',
    hideTimeOverride=false,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
      ],
    valueMaps=[],
    valueName='current',
  )
  .addTarget(
    prometheus.target(
      'mongodb_mongod_replset_number_of_members{service_name=~"$service"}',
      intervalFactor = 1,
      interval='5m',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 4,
        "x": 6,
        "y": 0
        },
  style=null,
)//59 singlestat
.addPanel(
  singlestat.new(
    'ReplSet Last Election',//title
    description='This shows the time since the last election.',
    format='s',
    datasource='Prometheus',
    decimals=1,
    editable=true,
    thresholds='',
    height='125px',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
      ],
    valueMaps=[],
    valueName='current',
    timeFrom='1m',
    postfix='s',
    postfixFontSize='70%',
    valueFontSize='70%',
  )
  .addTarget(
    prometheus.target(
      'time() - mongodb_mongod_replset_member_election_date{service_name=~"$service"}',
      intervalFactor = 1,
      interval='5m',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 4,
        "x": 10,
        "y": 0
        },
  style=null,
)//65 singlestat
.addPanel(
  singlestat.new(
    'ReplSet Lag',//title
    description='This panel shows how far behind in replication this member is if it is a secondary. This number may be high it the instance is running as a delayed secondary member.',
    format='s',
    datasource='Prometheus',
    decimals=1,
    editable=true,
    thresholds='',
    height='125px',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
      ],
    valueMaps=[],
    valueName='current',
    timeFrom='1m',
    postfixFontSize='80%',
  )
  .addTarget(
    prometheus.target(
      '(max(mongodb_mongod_replset_member_optime_date{state="PRIMARY", set="$replset"}) - min(mongodb_mongod_replset_member_optime_date{state="SECONDARY"} * on (name) group_left mongodb_mongod_replset_my_name{service_name=~"$service"})) or vector(0)',
      intervalFactor = 1,
      interval='5m',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 4,
        "x": 14,
        "y": 0
        },
  style=null,
)//77 singlestat
.addPanel(
  singlestat.new(
    'Storage Engine',//title
    description='This shows which storage engine the instance is configured with.',
    format='none',
    datasource='Prometheus',
    decimals=0,
    editable=true,
    thresholds='',
    height='125px',
    hideTimeOverride=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
      ],
    valueMaps=[],
    valueName='name',
    timeFrom='1m',
  )
  .addTarget(
    prometheus.target(
      'mongodb_mongod_storage_engine{service_name=~"$service"}',
      intervalFactor = 1,
      interval='5m',
      legendFormat='{{ engine }}',
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
)//78 singlestat
.addPanel(
  graphPanel.new(
    'Replication Operations',//title
    description='This shows the number of replicated commands that have been sent from the primary to this instance. This will always be empty on a primary instance.

*NOTE*: A single command (such as a call to `.updateMany()`) on the primary can generate multiple replicated commands on a secondary.',
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
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type!~"(command|getmore|query)"}[$interval]) or irate(mongodb_mongod_op_counters_repl_total{service_name=~"$service", type!~"(command|getmore|query)"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{type}}',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 0,
     "y": 3,
  },
  style=null,
)//63 graph
.addPanel(
  graphPanel.new(
    'Oplog Recovery Window',//title
    description='This shows how much time the oplog covers. The oplog is a capped (fixed size) collection and the amount of time can grow or shrink as workloads decrease or increase. You want to make sure the oplog is sized big enough to handle the time it takes for maintenance or to sync a secondary member.

Learn more about the [Oplog](https://docs.mongodb.com/manual/core/replica-set-oplog/).',
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
    formatY1='s',
  )
  .addTarget(
      prometheus.target(
        'time()-mongodb_mongod_replset_oplog_tail_timestamp{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Now to End',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_replset_oplog_head_timestamp{service_name=~"$service"}-mongodb_mongod_replset_oplog_tail_timestamp{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Oplog Range',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 12,
       "y": 3,
  },
  style=null,
)//27 graph
.addPanel(
  graphPanel.new(
    'Replication Lag',//title
    description='This shows the amount of time that a secondary is behind the primary. A high value could be due the secondary being delayed. If this instance is a normal secondary you will want to check the instance to determine why it is behind and resolve the issue.

Learn more about [Replication Lag](https://docs.mongodb.com/manual/tutorial/troubleshoot-replica-sets/#replica-set-replication-lag).',
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
    formatY1='s',
  )
  .addTarget(
      prometheus.target(
        '(max(mongodb_mongod_replset_member_optime_date{state="PRIMARY", set="$replset"}) - min(mongodb_mongod_replset_member_optime_date{state="SECONDARY"} * on (name) group_left mongodb_mongod_replset_my_name{service_name=~"$service"})) or vector(0)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Lag',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 0,
       "y": 10,
  },
  style=null,
)//14 graph
.addPanel(
  graphPanel.new(
    'Elections',//title
    description='This shows when elections occur in the replica set. An election happens whenever the primary instance is not accessible to the rest of the members. Looking at this graph over long periods of time can help you to correlate elections to other system events.

Learn more about [Replica set Elections](https://docs.mongodb.com/manual/core/replica-set-elections/).',
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
        'max(changes(mongodb_mongod_replset_member_election_date{service_name=~"$service"}[$interval]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Count',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 12,
       "y": 10,
  },
  style=null,
)//12 graph
.addPanel(
  graphPanel.new(
    'Member State Uptime',//title
    description='This graph shows all replica set members and the amount of time that each member was in a given state.',
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
    logBase1Y=10,
    minY1=0,
    formatY1='s',
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_replset_member_uptime{service_name=~"$service"}
* on (name) group_right(state) (max_over_time(mongodb_mongod_replset_my_name[$interval]) or max_over_time(mongodb_mongod_replset_my_name[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{ instance }} - {{state}}',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 0,
       "y": 17,
  },
  style=null,
)//76 graph
.addPanel(
  graphPanel.new(
    'Max Heartbeat Time',//title
    description='This chart shows the heartbeat time between this instance and all other instances in the replica set. If there is no heartbeat returned after 10 seconds the node in considered to be unreachable and would require intervention to determine the cause.',
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
    formatY1='s',
  )
  .addTarget(
      prometheus.target(
        'time() - max(mongodb_mongod_replset_member_last_heartbeat{service_name=~"$service"}) by (name) * on (name) group_right mongodb_mongod_replset_my_name',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{ instance }}',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 12,
       "y": 17,
  },
  style=null,
)//75 graph
.addPanel(
  graphPanel.new(
    'Max Member Ping Time',//title
    description='This shows the number of milliseconds that a round-trip packet required when communication with other members of the replica set. High values could indicate an issue such as network lag and should be looked into.',
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
    formatY1='ms',
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_replset_member_ping_ms{service_name=~"$service"}
* on (name) group_right(state) (max_over_time(mongodb_mongod_replset_my_name[$interval]) or max_over_time(mongodb_mongod_replset_my_name[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{ instance }}',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 0,
       "y": 24,
  },
  style=null,
)//13 graph
.addPanel(
  graphPanel.new(
    'Oplog Getmore Time',//title
    description="This is the number of milliseconds that the secondary member spends in getting receiving data from the instance it's replicating from.",
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
    formatY1='ms',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_repl_network_getmores_total_milliseconds{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_repl_network_getmores_total_milliseconds{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{instance}}',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 12,
       "y": 24,
  },
  style=null,
)//79 graph
.addPanel(
  graphPanel.new(
    'Oplog Operations',//title
    description='This shows the number of operations per second that the secondary member is receiving from its source.',
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
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_repl_preload_docs_num_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_repl_preload_docs_num_total{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Document Preload',
        metric='mongodb_mongod_metrics_repl_preload_indexes_num_total',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_repl_preload_indexes_num_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_repl_preload_indexes_num_total{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Index Preload',
        metric='mongodb_mongod_metrics_repl_preload_indexes_num_total',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_repl_apply_ops_total{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_repl_apply_ops_total{service_name=~"$service"}[5m])',
        legendFormat='Batch Apply',
        step=120,
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 0,
       "y": 31,
  },
  style=null,
)//81 graph
.addPanel(
  graphPanel.new(
    'Oplog Processing Time',//title
    description='This shows the amount of time it takes a secondary instance to apply data from the oplog.',
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
    formatY1='ms',
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_repl_preload_docs_total_milliseconds{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_repl_preload_docs_total_milliseconds{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Document Preload',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_repl_preload_indexes_total_milliseconds{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_repl_preload_indexes_total_milliseconds{service_name=~"$service"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Index Preload',
        metric='mongodb_mongod_metrics_repl_preload_indexes_total_milliseconds',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mongodb_mongod_metrics_repl_apply_batches_total_milliseconds{service_name=~"$service"}[$interval]) or irate(mongodb_mongod_metrics_repl_apply_batches_total_milliseconds{service_name=~"$service"}[5m])',
        intervalFactor=1,
        interval='$interval',
        legendFormat='Batch Apply',
        metric='mongodb_mongod_metrics_repl_preload_indexes_total_milliseconds',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 12,
       "y": 31,
  },
  style=null,
)//84 graph
.addPanel(
  graphPanel.new(
    'Oplog Buffered Operations',//title
    description='This shows the number of operations that are in the oplog buffer waiting to be applied on the secondary member.',
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
    formatY1='ops',
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_metrics_repl_buffer_count{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Current',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 0,
        "y": 38,
  },
  style=null,
)//85 graph
.addPanel(
  graphPanel.new(
    'Oplog Buffer Capacity',//title
    description="This shows the maximum size of the oplog buffer and the current amount of data being stored in the buffer. The maximum size is not configurable currently and is set by the `mongod` process.",
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
    formatY1='bytes',
    logBase1Y=10,
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_metrics_repl_buffer_size_bytes{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Used',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'mongodb_mongod_metrics_repl_buffer_max_size_bytes{service_name=~"$service"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Max',
        step=300,
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 12,
        "y": 38,
  },
  style=null,
)//80 graph
