local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local text = grafana.text;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;

dashboard.new(
  'PXC/Galera Cluster Overview',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=16,
  version=1,
  tags=['Percona','HA'],
  iteration=1541499518682,
  uid="s_k9wGNiz",
  timepicker = timepicker.new(
    hidden = false,
    collapse= false,
    enable= true,
    notice=false,
    now= true,
    status='Stable',
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
  'service_names',
  'Prometheus',
  'label_values(mysql_global_status_wsrep_local_state, service_name)',
  label='Instance',
  tagValuesQuery='',
  refresh='load',
  sort=0,
  tagsQuery='',
  multi=true,
  includeAll=true,
  ),
)
.addTemplate(
  template.new(
  'cluster',
  'Prometheus',
  'label_values(mysql_galera_variables_info{service_name=~"$service_names"}, wsrep_cluster_name)',
  label='Cluster',
  refresh='load',
  sort=1,
  refresh_on_load=false,
  allFormat='glob',
  multiFormat='regex values',
  ),
)
.addPanel(
  graphPanel.new(
  'Percona XtraDB / Galera Cluster Size',//title
  fill=0,
  linewidth=2,
  decimals=0,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=true,
  legend_show=false,
  editable=true,
  value_type='cumulative',
  format='short',
  logBase1Y=2,
  logBase2Y=1,
  steppedLine=true,
  transparent=true,
  )
  .addSeriesOverride(
      {
        "alias": "Size",
        "color": "#5195CE"
      }
  )
  .addTarget(
    prometheus.target(
    'min((min_over_time(mysql_global_status_wsrep_cluster_size[$interval]) or min_over_time(mysql_global_status_wsrep_cluster_size[5m])) *
    on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"})',
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
        "y": 0,
      },
  style=null,
)//42 graph
.addPanel(
  graphPanel.new(
  'Flow Control Paused Time',//title
  fill=2,
  linewidth=2,
  decimals=0,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  value_type='cumulative',
  format='short',
  formatY1='percentunit',
  logBase1Y=1,
  logBase2Y=1,
  )
  .addTarget(
    prometheus.target(
    'clamp_max((rate(mysql_global_status_wsrep_flow_control_paused_ns[$interval]) or irate(mysql_global_status_wsrep_flow_control_paused_ns[5m]))/1000000000 * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"},1)',
    intervalFactor = 1,
    legendFormat='{{ service_name }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=300,
    )
  )
  ,gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 4,
      },
  style=null,
)//52 graph
.addPanel(
  graphPanel.new(
  'Flow Control Messages Sent',//title
  fill=2,
  linewidth=2,
  decimals=0,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  value_type='cumulative',
  format='short',
  logBase1Y=1,
  logBase2Y=1,
  )
  .addTarget(
    prometheus.target(
    '(rate(mysql_global_status_wsrep_flow_control_sent[$interval]) or irate(mysql_global_status_wsrep_flow_control_sent[5m])) * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{ service_name }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=300,
    )
  )
  ,gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 4,
      },
  style=null,
)//53 graph
.addPanel(
  graphPanel.new(
  'Writeset Inbound Traffic',//title
  fill=6,
  linewidth=2,
  decimals=0,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  formatY2='none',
  formatY1='bytes',
  logBase1Y=1,
  logBase2Y=1,
  stack=true,
  )
  .addTarget(
    prometheus.target(
    '(rate(mysql_global_status_wsrep_received_bytes[$interval]) or irate(mysql_global_status_wsrep_received_bytes[5m])) * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{ service_name }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=300,
    )
  )
  ,gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 11,
      },
  style=null,
)//9 graph
.addPanel(
  graphPanel.new(
  'Writeset Outbound Traffic',//title
  fill=6,
  linewidth=2,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=false,
  editable=true,
  formatY1='bytes',
  formatY2='none',
  logBase1Y=1,
  logBase2Y=1,
  stack=true,
  )
  .addTarget(
    prometheus.target(
    '(rate(mysql_global_status_wsrep_replicated_bytes[$interval]) or irate(mysql_global_status_wsrep_replicated_bytes[5m])) * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{ service_name }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=300,
    )
  )
  ,gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 11,
      },
  style=null,
)//47 graph
.addPanel(
  graphPanel.new(
  'Receive Queue',//title
  fill=2,
  linewidth=2,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  format='short',
  logBase1Y=1,
  logBase2Y=1,
  value_type='cumulative',
  )
  .addTarget(
    prometheus.target(
    'mysql_global_status_wsrep_local_recv_queue * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{ service_name }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=300,
    )
  )
  ,gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 18,
      },
  style=null,
)//48 graph
.addPanel(
  graphPanel.new(
  'Send Queue',//title
  fill=2,
  linewidth=2,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  format='short',
  logBase1Y=1,
  logBase2Y=1,
  value_type='cumulative',
  )
  .addTarget(
    prometheus.target(
    'mysql_global_status_wsrep_local_send_queue * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{ service_name }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=300,
    )
  )
  ,gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 18,
      },
  style=null,
)//49 graph
.addPanel(
  graphPanel.new(
  'Transactions Received',//title
  fill=2,
  linewidth=2,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  editable=true,
  format='short',
  logBase1Y=1,
  logBase2Y=1,
  value_type='cumulative',
  )
  .addTarget(
    prometheus.target(
    '(rate(mysql_global_status_wsrep_received[$interval]) or irate(mysql_global_status_wsrep_received[5m])) * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{ service_name }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=300,
    )
  )
  ,gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 25,
      },
  style=null,
)//2 graph
.addPanel(
  graphPanel.new(
  'Transactions Replicated',//title
  fill=2,
  linewidth=2,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_show=true,
  editable=true,
  format='short',
  logBase1Y=1,
  logBase2Y=1,
  value_type='cumulative',
  )
  .addTarget(
    prometheus.target(
    '(rate(mysql_global_status_wsrep_replicated[$interval]) or irate(mysql_global_status_wsrep_replicated[5m])) * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{ service_name }}',
    refId='A',
    interval='$interval',
    calculatedInterval='2m',
    step=300,
    )
  )
  ,gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 25,
      },
  style=null,
)//50 graph
.addPanel(
  graphPanel.new(
  'Average Incoming Transaction Size',//title
  fill=2,
  linewidth=2,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=false,
  legend_show=true,
  editable=true,
  formatY1='bytes',
  formatY2='short',
  logBase1Y=1,
  logBase2Y=1,
  )
  .addTarget(
    prometheus.target(
    '(rate(mysql_global_status_wsrep_received_bytes[$interval]) / rate(mysql_global_status_wsrep_received[$interval]) or irate(mysql_global_status_wsrep_received_bytes[5m]) / irate(mysql_global_status_wsrep_received[5m])) * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{ service_name }}',
    refId='C',
    interval='$interval',
    calculatedInterval='2m',
    step=300,
    )
  )
  ,gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 32,
      },
  style=null,
)//11 graph
.addPanel(
  graphPanel.new(
  'Average Replicated Transaction Size',//title
  fill=2,
  linewidth=2,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=false,
  legend_show=true,
  editable=true,
  formatY1='bytes',
  formatY2='short',
  logBase1Y=1,
  logBase2Y=1,
  )
  .addTarget(
    prometheus.target(
    '(rate(mysql_global_status_wsrep_replicated_bytes[$interval]) / rate(mysql_global_status_wsrep_replicated[$interval]) or irate(mysql_global_status_wsrep_replicated_bytes[5m]) / irate(mysql_global_status_wsrep_replicated[5m])) * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{ service_name }}',
    refId='C',
    interval='$interval',
    calculatedInterval='2m',
    step=300,
    )
  )
  ,gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 32,
      },
  style=null,
)//51 graph
.addPanel(
  graphPanel.new(
  'FC Trigger Low Limit',//title
  fill=2,
  linewidth=2,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_show=true,
  editable=true,
  format='short',
  logBase1Y=1,
  logBase2Y=1,
  )
  .addTarget(
    prometheus.target(
    'mysql_global_status_wsrep_flow_control_interval_low * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{ service_name }}',
    refId='C',
    interval='$interval',
    )
  )
  ,gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 39,
      },
  style=null,
)//54 graph
.addPanel(
  graphPanel.new(
  'FC Trigger High Limit',//title
  fill=2,
  linewidth=2,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=false,
  legend_show=true,
  editable=true,
  format='short',
  logBase1Y=1,
  logBase2Y=1,
  )
  .addTarget(
    prometheus.target(
    'mysql_global_status_wsrep_flow_control_interval_high * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{ service_name }}',
    refId='A',
    interval='$interval',
    )
  )
  ,gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 39,
      },
  style=null,
)//55 graph
.addPanel(
  graphPanel.new(
  'IST Progress',//title
  fill=2,
  linewidth=2,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=true,
  legend_show=true,
  editable=true,
  format='short',
  logBase1Y=1,
  logBase2Y=1,
  )
  .addTarget(
    prometheus.target(
    'mysql_global_status_wsrep_ist_receive_seqno_start * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{service_name}} first',
    refId='A',
    interval='$interval',
    )
  )
  .addTarget(
    prometheus.target(
    'mysql_global_status_wsrep_ist_receive_seqno_current * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{service_name}} current',
    refId='B',
    interval='$interval',
    hide=false,
    )
  )
  .addTarget(
    prometheus.target(
    'mysql_global_status_wsrep_ist_receive_seqno_end * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{service_name}} last',
    refId='C',
    interval='$interval',
    )
  )
  ,gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 46,
      },
  style=null,
)//56 graph
.addPanel(
  graphPanel.new(
  'Average Galera Replication Latency',//title
  fill=0,
  linewidth=2,
  lines=true,
  datasource='Prometheus',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_show=true,
  editable=true,
  formatY1='s',
  formatY2='short',
  logBase1Y=1,
  logBase2Y=1,
  )
  .addTarget(
    prometheus.target(
    '(rate(mysql_global_status_wsrep_replicated_bytes[$interval]) / rate(mysql_global_status_wsrep_replicated[$interval]) or irate(mysql_global_status_wsrep_replicated_bytes[5m]) / irate(mysql_global_status_wsrep_replicated[5m])) * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 2,
    legendFormat='{{service_name}}',
    refId='A',
    interval='$interval',
    hide=true,
    )
  )
  .addTarget(
    prometheus.target(
    'avg_over_time(mysql_global_status_wsrep_evs_repl_latency{aggregator="Average"}[$interval]) * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{service_name}} - Latency Average',
    refId='B',
    interval='$interval',
    )
  )
  ,gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 53,
      },
  style=null,
)//57 graph
.addPanel(
  graphPanel.new(
  'Maximum  Galera Replication Latency',//title
  fill=1,
  linewidth=1,
  lines=false,
  datasource='Prometheus',
  points=true,
  pointradius=1,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_show=true,
  editable=true,
  formatY1='s',
  formatY2='short',
  logBase1Y=1,
  logBase2Y=1,
  )
  .addTarget(
    prometheus.target(
    'max_over_time(mysql_global_status_wsrep_evs_repl_latency{aggregator="Maximum"}[$interval]) * on (service_name) group_left mysql_galera_variables_info{wsrep_cluster_name="$cluster"}',
    intervalFactor = 1,
    legendFormat='{{service_name}} - Latency Maximum',
    refId='A',
    interval='$interval',
    hide=true,
    )
  )
  ,gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 53,
      },
  style=null,
)//58 graph
