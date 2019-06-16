local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local singlestat = grafana.singlestat;

dashboard.new(
  'PXC/Galera Graphs',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=1,
  tags=['Percona','HA'],
  iteration=1556631251514,
  uid="Vwstci7iz",
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
  'node_name',
  'Prometheus',
  'label_values(mysql_global_status_wsrep_local_state, node_name)',
  definition='label_values(mysql_global_status_wsrep_local_state, node_name)',
  label='Node',
  tagValuesQuery='',
  refresh='load',
  sort=1,
  tagsQuery='',
  multi=true,
  includeAll=true,
  ),
)
.addTemplate(
  template.new(
  'cluster',
  'Prometheus',
  'label_values(mysql_galera_variables_info{node_name=~"$node_name"}, wsrep_cluster_name)',
  definition='label_values(mysql_galera_variables_info{node_name=~"$node_name"}, wsrep_cluster_name)',
  label='Cluster',
  refresh='load',
  sort=1,
  refresh_on_load=false,
  allFormat='glob',
  multiFormat='regex values',
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(mysql_galera_variables_info{wsrep_cluster_name ="$cluster"}, service_name)',
  definition='label_values(mysql_galera_variables_info{wsrep_cluster_name ="$cluster"}, service_name)',
  label='Service',
  refresh='load',
  sort=1,
  refresh_on_load=false,
  allFormat='glob',
  multiFormat='regex values',
  ),
)
.addPanel(
  singlestat.new(
    'Ready to Accept Queries',//title
    format='none',
    datasource='Prometheus',
    valueName='current',
    thresholds='0.5,1',
    editable=true,
    prefixFontSize='80%',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    interval='$interval',
    height='125px',
    colorValue=true,
    valueMaps=[
                {
                    "op": "=",
                    "text": "ON",
                    "value": "1"
                },
                {
                    "op": "=",
                    "text": "OFF",
                    "value": "0"
                }
            ],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_status_wsrep_ready{service_name=~"$service"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
    "h": 4,
    "w": 4,
    "x": 0,
    "y": 0,
  },
  style=null,
)//50 singlestat
.addPanel(
  singlestat.new(
    'Local State',//title
    format='none',
    datasource='Prometheus',
    valueName='current',
    thresholds='2,4',
    editable=true,
    prefixFontSize='80%',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    interval='$interval',
    height='125px',
    colorValue=true,
    valueMaps=[
                {
                    "op": "=",
                    "text": "Joining",
                    "value": "1"
                },
                {
                    "op": "=",
                    "text": "Donor/Desynced",
                    "value": "2"
                },
                {
                    "op": "=",
                    "text": "Joined",
                    "value": "3"
                },
                {
                    "op": "=",
                    "text": "Synced",
                    "value": "4"
                }
            ],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_status_wsrep_local_state{service_name=~"$service"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
      "h": 4,
      "w": 4,
      "x": 4,
      "y": 0,
  },
  style=null,
)//49 singlestat
.addPanel(
  singlestat.new(
    'Desync Mode',//title
    format='none',
    datasource='Prometheus',
    valueName='current',
    thresholds='0.5,1',
    editable=true,
    prefixFontSize='80%',
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)",
    ],
    interval='$interval',
    height='125px',
    colorValue=true,
    valueMaps=[
                {
                    "op": "=",
                    "text": "ON",
                    "value": "1"
                },
                {
                    "op": "=",
                    "text": "OFF",
                    "value": "0"
                }
            ],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_variables_wsrep_desync{service_name=~"$service"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
    "h": 4,
    "w": 4,
    "x": 8,
    "y": 0,
  },
  style=null,
)//53 singlestat
.addPanel(
  singlestat.new(
    'Cluster Status',//title
    format='none',
    datasource='Prometheus',
    valueName='current',
    thresholds='0.5,1',
    editable=true,
    prefixFontSize='80%',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    interval='$interval',
    height='125px',
    colorValue=true,
    valueMaps=[
                {
                    "op": "=",
                    "text": "Primary",
                    "value": "1"
                },
                {
                    "op": "=",
                    "text": "Non-primary",
                    "value": "0"
                }
            ],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_status_wsrep_cluster_status{service_name=~"$service"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
      "h": 4,
      "w": 4,
      "x": 12,
      "y": 0,
  },
  style=null,
)//51 singlestat
.addPanel(
  singlestat.new(
    'gcache Size',//title
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    thresholds='90,95',
    editable=true,
    prefixFontSize='80%',
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)",
    ],
    interval='$interval',
    height='125px',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'mysql_galera_gcache_size_bytes{service_name=~"$service"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
    "h": 4,
    "w": 4,
    "x": 16,
    "y": 0,
  },
  style=null,
)//48 singlestat
.addPanel(
  singlestat.new(
    'FC (normal traffic)',//title
    format='short',
    datasource='Prometheus',
    valueName='current',
    thresholds='0.5,1',
    editable=true,
    maxPerRow=6,
    colors=[
      "#ef843c",
      "#508642",
      "#299c46",
    ],
    colorValue=true,
    valueMaps=[
                {
                    "op": "=",
                    "text": "OFF",
                    "value": "0"
                },
                {
                    "op": "=",
                    "text": "ON",
                    "value": "1"
                },
                {
                    "op": "=",
                    "text": "N/A",
                    "value": "null"
                }
            ],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_status_wsrep_flow_control_status{service_name=~"$service"}',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
  ),
  gridPos = {
      "h": 4,
      "w": 4,
      "x": 20,
      "y": 0,
  },
  style=null,
)//55 singlestat
.addPanel(
  graphPanel.new(
  'Galera Replication Latency',//title
  fill=0,
  linewidth=2,
  decimals=0,
  bars=true,
  lines=false,
  datasource='Prometheus',
  description='Shows figures for the replication latency on group communication. It measures latency from the time point when a message is sent out to the time point when a message is received. As replication is a group operation, this essentially gives you the slowest ACK and longest RTT in the cluster.',
  points=false,
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=true,
  editable=true,
  value_type='cumulative',
  formatY1='s',
  formatY2='short',
  logBase1Y=1,
  logBase2Y=1,
  links=[
        {
          "title": "Galera Documentation",
          "type": "absolute",
          "url": "http://galeracluster.com/documentation-webpages/galerastatusvariables.html#wsrep-evs-repl-latency"
        }
      ],
  aliasColors={
      "Maximum": "#806eb7",
      "Standard Deviation": "#7eb26d"
    },

  )
  .addTarget(
    prometheus.target(
    'max_over_time(mysql_global_status_wsrep_evs_repl_latency{service_name=~"$service", aggregator="Maximum"}[$interval]) or
    max_over_time(mysql_global_status_wsrep_evs_repl_latency{service_name=~"$service", aggregator="Maximum"}[5m])',
    intervalFactor = 1,
    legendFormat='{{ aggregator }}',
    refId='A',
    interval='$interval',
    step=300,
    )
    )
  .addTarget(
      prometheus.target(
      'avg_over_time(mysql_global_status_wsrep_evs_repl_latency{service_name=~"$service", aggregator="Standard Deviation"}[$interval]) or
      avg_over_time(mysql_global_status_wsrep_evs_repl_latency{service_name=~"$service", aggregator="Standard Deviation"}[5m])',
      intervalFactor = 1,
      legendFormat='{{ aggregator }}',
      refId='B',
      interval='$interval',
      step=300,
      )
      )
  .addTarget(
        prometheus.target(
        'avg_over_time(mysql_global_status_wsrep_evs_repl_latency{service_name=~"$service", aggregator="Average"}[$interval]) or
        avg_over_time(mysql_global_status_wsrep_evs_repl_latency{service_name=~"$service", aggregator="Average"}[5m])',
        intervalFactor = 1,
        legendFormat='{{ aggregator }}',
        refId='C',
        interval='$interval',
        step=300,
        )
        )
  .addTarget(
          prometheus.target(
          'min_over_time(mysql_global_status_wsrep_evs_repl_latency{service_name=~"$service", aggregator="Minimum"}[$interval]) or
          min_over_time(mysql_global_status_wsrep_evs_repl_latency{service_name=~"$service", aggregator="Minimum"}[5m])',
          intervalFactor = 1,
          legendFormat='{{ aggregator }}',
          refId='D',
          interval='$interval',
          step=300,
          )
  ),gridPos={
        "h": 7,
        "w": 24,
        "x": 0,
        "y": 4,
      },
  style=null,
)//42 graph
.addPanel(
  graphPanel.new(
    'Galera Replication Queues',//title
    fill=2,
    linewidth=2,
    lines=true,
    datasource='Prometheus',
    description='Shows the length of receive and send queues.',
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
    'max_over_time(mysql_global_status_wsrep_local_recv_queue{service_name=~"$service"}[$interval]) or
    max_over_time(mysql_global_status_wsrep_local_recv_queue{service_name=~"$service"}[5m])',
    intervalFactor = 1,
    legendFormat='Receive Queue',
    refId='A',
    calculatedInterval='2m',
    interval='$interval',
    step=300,
    )
    )
  .addTarget(
      prometheus.target(
      'max_over_time(mysql_global_status_wsrep_local_send_queue{service_name=~"$service"}[$interval]) or
      max_over_time(mysql_global_status_wsrep_local_send_queue{service_name=~"$service"}[5m])',
      intervalFactor = 1,
      legendFormat='Send Queue',
      refId='B',
      interval='$interval',
      calculatedInterval='2m',
      step=300,
      )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 11,
      },
  style=null,
)//39 graph
.addPanel(
  graphPanel.new(
    'Galera Cluster Size',//title
    fill=0,
    linewidth=2,
    lines=true,
    datasource='Prometheus',
    description='Shows the number of members currently connected to the cluster.',
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
      'max_over_time(mysql_global_status_wsrep_cluster_size{service_name=~"$service"}[$interval]) or
      max_over_time(mysql_global_status_wsrep_cluster_size{service_name=~"$service"}[5m])',
      intervalFactor = 1,
      legendFormat='Size',
      refId='C',
      interval='$interval',
      calculatedInterval='2m',
      step=300,
      )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 11,
      },
  style=null,
)//54 graph
.addPanel(
  graphPanel.new(
    'Galera Flow Control',//title
    fill=0,
    linewidth=2,
    lines=true,
    datasource='Prometheus',
    description='Shows the number of FC_PAUSE events sent/received. They are sent by a node when its replication queue gets too full. If a node is sending out FC messages it indicates a problem.',
    points=false,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    editable=true,
    value_type='cumulative',
    formatY1='short',
    formatY2='percentunit',
    logBase1Y=1,
    logBase2Y=1,
  )
  .addSeriesOverride(
     {
        "alias": "Paused due to Flow Control",
        "linewidth": 1,
        "yaxis": 2
      }
  )
  .addTarget(
      prometheus.target(
      'rate(mysql_global_status_wsrep_flow_control_recv{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_flow_control_recv{service_name=~"$service"}[5m])',
      intervalFactor = 1,
      legendFormat='FC Messages Received',
      refId='A',
      interval='$interval',
      calculatedInterval='2m',
      step=300,
      )
      )
  .addTarget(
     prometheus.target(
          'rate(mysql_global_status_wsrep_flow_control_sent{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_flow_control_sent{service_name=~"$service"}[5m])',
          intervalFactor = 1,
          legendFormat='FC Messages Sent',
          refId='B',
          interval='$interval',
          calculatedInterval='2m',
          step=300,
      )
          )
  .addTarget(
        prometheus.target(
            '(rate(mysql_global_status_wsrep_flow_control_paused_ns{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_flow_control_paused_ns{service_name=~"$service"}[5m]))/1000000000',
            intervalFactor = 1,
           legendFormat='Paused due to Flow Control',
            refId='C',
            interval='$interval',
            calculatedInterval='2m',
          step=300,
      )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 18,
      },
  style=null,
)//45 graph
.addPanel(
  graphPanel.new(
    'Galera Parallelization Efficiency',//title
    fill=0,
    linewidth=2,
    lines=true,
    datasource='Prometheus',
    description='Shows the average distances between highest and lowest seqno that are concurrently applied, committed and can be possibly applied in parallel (potential degree of parallelization).',
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
      'max_over_time(mysql_global_status_wsrep_apply_window{service_name=~"$service"}[$interval]) or
      max_over_time(mysql_global_status_wsrep_apply_window{service_name=~"$service"}[5m])',
      intervalFactor = 1,
      legendFormat='Apply Window',
      refId='A',
      interval='$interval',
      calculatedInterval='2m',
      step=300,
      )
      )
  .addTarget(
     prometheus.target(
          'max_over_time(mysql_global_status_wsrep_commit_window{service_name=~"$service"}[$interval]) or
          max_over_time(mysql_global_status_wsrep_commit_window{service_name=~"$service"}[5m])',
          intervalFactor = 1,
          legendFormat='Commit Window',
          refId='B',
          interval='$interval',
          calculatedInterval='2m',
          step=300,
      )
          )
  .addTarget(
        prometheus.target(
            'max_over_time(mysql_global_status_wsrep_cert_deps_distance{service_name=~"$service"}[$interval]) or
            max_over_time(mysql_global_status_wsrep_cert_deps_distance{service_name=~"$service"}[5m])',
            intervalFactor = 1,
           legendFormat='Cert Deps Distance',
            refId='C',
            interval='$interval',
            calculatedInterval='2m',
          step=300,
      )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 18,
      },
  style=null,
)//40 graph
.addPanel(
  graphPanel.new(
    'Galera Writing Conflicts',//title
    fill=2,
    linewidth=2,
    lines=true,
    datasource='Prometheus',
    description='Shows the number of local transactions being committed on this node that failed certification (some other node had a commit that conflicted with ours) – client received deadlock error on commit and also the number of local transactions in flight on this node that were aborted because they locked something an applier thread needed – deadlock error anywhere in an open transaction. Spikes in the graph may indicate writing to the same table potentially the same rows from 2 nodes.',
    points=false,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    editable=true,
    value_type='cumulative',
    format='ops',
    logBase1Y=1,
    logBase2Y=1,
  )
  .addTarget(
      prometheus.target(
      'rate(mysql_global_status_wsrep_local_cert_failures{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_local_cert_failures{service_name=~"$service"}[5m])',
      intervalFactor = 1,
      legendFormat='Local Cert Failures',
      refId='A',
      interval='$interval',
      calculatedInterval='2m',
      step=300,
      )
      )
  .addTarget(
     prometheus.target(
          'rate(mysql_global_status_wsrep_local_bf_aborts{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_local_bf_aborts{service_name=~"$service"}[5m])',
          intervalFactor = 1,
          legendFormat='Local Bf Aborts',
          refId='B',
          interval='$interval',
          calculatedInterval='2m',
          step=300,
      )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 25,
      },
  style=null,
)//41 graph
.addPanel(
  graphPanel.new(
    'Available Downtime before SST Required',//title
    fill=2,
    linewidth=2,
    lines=true,
    datasource='Prometheus',
    description='Shows for how long the node can be taken out of the cluster before SST is required. SST is a full state transfer method.',
    points=false,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    editable=true,
    value_type='cumulative',
    formatY1='s',
    formatY2='short',
    logBase1Y=1,
    logBase2Y=1,
  )
  .addSeriesOverride(
    {
        "alias": "Time (Instant)",
        "color": "#447ebc",
        "lines": false,
        "pointradius": 1,
        "points": true
      }
  )
  .addTarget(
      prometheus.target(
      'mysql_galera_gcache_size_bytes{service_name=~"$service"} /
      (rate(mysql_global_status_wsrep_replicated_bytes{service_name=~"$service"}[1h])+rate(mysql_global_status_wsrep_received_bytes{service_name=~"$service"}[1h]))',
      intervalFactor = 1,
      legendFormat='Time (1h avg)',
      refId='A',
      interval='1h',
      calculatedInterval='2m',
      step=300,
      )
      )
  .addTarget(
     prometheus.target(
          'mysql_galera_gcache_size_bytes{service_name=~"$service"} /
          ((rate(mysql_global_status_wsrep_replicated_bytes{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_replicated_bytes{service_name=~"$service"}[5m])) +
          (rate(mysql_global_status_wsrep_received_bytes{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_received_bytes{service_name=~"$service"}[5m])))',
          intervalFactor = 1,
          legendFormat='Time (Instant)',
          refId='B',
          interval='$interval',
          hide=false,

      )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 25,
      },
  style=null,
)//47 graph
.addPanel(
  graphPanel.new(
    'Galera Writeset Count',//title
    fill=2,
    linewidth=2,
    lines=true,
    datasource='Prometheus',
    description='Shows the count of transactions received from the cluster (any other node) and replicated to the cluster (from this node).',
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
      'rate(mysql_global_status_wsrep_received{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_received{service_name=~"$service"}[5m])',
      intervalFactor = 1,
      legendFormat='Transactions Received',
      refId='A',
      interval='$interval',
      calculatedInterval='2m',
      step=300,
      )
      )
  .addTarget(
     prometheus.target(
          'rate(mysql_global_status_wsrep_replicated{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_replicated{service_name=~"$service"}[5m])',
          intervalFactor = 1,
          legendFormat='Transactions Replicated',
          refId='B',
          interval='$interval',
          calculatedInterval='2m',
          step=300,
      )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 32,
      },
  style=null,
)//2 graph
.addPanel(
  graphPanel.new(
    'Galera Writeset Size',//title
    fill=2,
    linewidth=2,
    lines=true,
    datasource='Prometheus',
    description='Shows the average transaction size received/replicated.',
    points=false,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    editable=true,
    formatY1='bytes',
    formatY2='short',
    logBase1Y=1,
    logBase2Y=1,
  )
  .addTarget(
      prometheus.target(
      'rate(mysql_global_status_wsrep_received_bytes{service_name=~"$service"}[$interval]) / rate(mysql_global_status_wsrep_received{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_received_bytes{service_name=~"$service"}[5m]) / irate(mysql_global_status_wsrep_received{service_name=~"$service"}[5m])',
      intervalFactor = 1,
      legendFormat='Incoming Transaction Size',
      refId='C',
      interval='$interval',
      calculatedInterval='2m',
      step=300,
      )
      )
  .addTarget(
     prometheus.target(
          'rate(mysql_global_status_wsrep_replicated_bytes{service_name=~"$service"}[$interval]) / rate(mysql_global_status_wsrep_replicated{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_replicated_bytes{service_name=~"$service"}[5m]) / irate(mysql_global_status_wsrep_replicated{service_name=~"$service"}[5m])',
          intervalFactor = 1,
          legendFormat='Replicating Transaction Size',
          refId='A',
          interval='$interval',
          calculatedInterval='2m',
          step=300,
      )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 32,
      },
  style=null,
)//11 graph
.addPanel(
  graphPanel.new(
    'Galera Writeset Traffic',//title
    fill=6,
    linewidth=2,
    lines=true,
    datasource='Prometheus',
    description='Shows the bytes of data received from the cluster (any other node) and replicated to the cluster (from this node).',
    points=false,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    editable=true,
    formatY1='bytes',
    formatY2='none',
    logBase1Y=1,
    logBase2Y=1,
    stack=true,
  )
  .addTarget(
      prometheus.target(
      'rate(mysql_global_status_wsrep_received_bytes{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_received_bytes{service_name=~"$service"}[5m])',
      intervalFactor = 1,
      legendFormat='Inbound',
      refId='A',
      interval='$interval',
      calculatedInterval='2m',
      step=300,
      )
      )
  .addTarget(
     prometheus.target(
          'rate(mysql_global_status_wsrep_replicated_bytes{service_name=~"$service"}[$interval]) or irate(mysql_global_status_wsrep_replicated_bytes{service_name=~"$service"}[5m])',
          intervalFactor = 1,
          legendFormat='Outbound',
          refId='B',
          interval='$interval',
          calculatedInterval='2m',
          step=300,
      )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 39,
      },
  style=null,
)//9 graph
.addPanel(
  graphPanel.new(
    'Galera Network Usage Hourly',//title
    fill=6,
    linewidth=2,
    lines=false,
    bars=true,
    datasource='Prometheus',
    description='Shows the bytes of data received from the cluster (any other node) and replicated to the cluster (from this node).',
    points=false,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    editable=true,
    formatY1='bytes',
    formatY2='none',
    logBase1Y=1,
    logBase2Y=1,
    stack=true,
  )
  .addTarget(
      prometheus.target(
      'increase(mysql_global_status_wsrep_received_bytes{service_name=~"$service"}[1h])',
      intervalFactor = 1,
      legendFormat='Received',
      refId='A',
      interval='1h',
      calculatedInterval='2m',
      step=3600,
      )
      )
  .addTarget(
     prometheus.target(
          'increase(mysql_global_status_wsrep_replicated_bytes{service_name=~"$service"}[1h])',
          intervalFactor = 1,
          legendFormat='Replicated',
          refId='B',
          interval='1h',
          calculatedInterval='2m',
          step=3600,
      )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 39,
      },
  style=null,
)//38 graph
