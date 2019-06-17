local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local row = grafana.row;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local singlestat = grafana.singlestat;

dashboard.new(
  'PXC/Galera Hosts Compare',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=1,
  tags=['Percona','HA'],
  iteration=1556649251829,
  uid="GmicprYiz",
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
  'instance',
  'Prometheus',
  'label_values(mysql_global_status_wsrep_local_state, instance)',
  label='Instance',
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
  'label_values(mysql_galera_variables_info{instance=~"$instance"}, wsrep_cluster_name)',
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
  label='Service',
  refresh='load',
  sort=1,
  refresh_on_load=false,
  allFormat='glob',
  multiFormat='regex values',
  multi=true,
  definition='label_values(mysql_galera_variables_info{wsrep_cluster_name ="$cluster"}, service_name)',
  includeAll=true,
  ),
)
.addPanel(
    row.new(
      title='General Metrics',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0,
    },
    style=null,
)//95 row
.addPanel(
  singlestat.new(
    '$service - Ready to Accept Queries',//title
    format='none',
    editable=true,
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='0.5,1',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    repeat='service',
    repeatDirection='v',
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
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
    "h": 2,
    "w": 4,
    "x": 0,
    "y": 1,
  },
  style=null,
)//50 singlestat
.addPanel(
  singlestat.new(
    '$service - Local State',//title
    format='none',
    editable=true,
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='2,4',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    repeat='service',
    repeatDirection='v',
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
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
      "h": 2,
      "w": 4,
      "x": 4,
      "y": 1,
  },
  style=null,
)//171 singlestat
.addPanel(
  singlestat.new(
    '$service - Desync Mode',//title
    format='none',
    editable=true,
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='0.5,1',
    colors=[
        "rgba(50, 172, 45, 0.97)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(245, 54, 54, 0.9)",
    ],
    repeat='service',
    repeatDirection='v',
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
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
      "h": 2,
      "w": 4,
      "x": 8,
      "y": 1,
  },
  style=null,
)//172 singlestat
.addPanel(
  singlestat.new(
    '$service - Cluster Status',//title
    format='none',
    editable=true,
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='0.5,1',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    repeat='service',
    repeatDirection='v',
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
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
      "h": 2,
      "w": 4,
      "x": 12,
      "y": 1,
  },
  style=null,
)//173 singlestat
.addPanel(
  singlestat.new(
    '$service - gcache Size',//title
    format='bytes',
    editable=true,
    datasource='Prometheus',
    valueName='current',
    colorValue=false,
    thresholds='90,95',
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)",
    ],
    repeat='service',
    repeatDirection='v',
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
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
      "h": 2,
      "w": 4,
      "x": 16,
      "y": 1,
  },
  style=null,
)//174 singlestat
.addPanel(
  singlestat.new(
    '$service - FC (normal traffic)',//title
    format='short',
    editable=true,
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='0.5,1',
    colors=[
      "#ef843c",
      "#508642",
      "#299c46",
    ],
    repeat='service',
    repeatDirection='v',
    height='125px',
    maxPerRow=6,
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
    "h": 2,
    "w": 4,
    "x": 20,
    "y": 1,
  },
  style=null,
)//55 singlestat
.addPanel(
  graphPanel.new(
  'Galera Cluster Size',//title
  description='Shows the number of members currently connected to the cluster.',
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
  legend_show=true,
  legend_rightSide=true,
  editable=true,
  value_type='cumulative',
  format='short',
  logBase1Y=1,
  logBase2Y=1,
  )
  .addTarget(
    prometheus.target(
    '(max_over_time(mysql_global_status_wsrep_cluster_size[$interval]) or \nmax_over_time(mysql_global_status_wsrep_cluster_size[5m])) * on(service_name) group_left(wsrep_cluster_name) (mysql_galera_variables_info{wsrep_cluster_name=\"$cluster\"})',
    intervalFactor = 1,
    legendFormat='{{service_name}}',
    refId='A',
    interval='$interval',
    )
  ),gridPos={
    "h": 4,
    "w": 24,
    "x": 0,
    "y": 5,
      },
  style=null,
)//54 graph
.addPanel(
    row.new(
      title='Galera Replication Latency',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
      '$service',//title
      description='Shows figures for the replication latency on group communication. It measures latency from the time point when a message is sent out to the time point when a message is received. As replication is a group operation, this essentially gives you the slowest ACK and longest RTT in the cluster.',
      fill=0,
      bars=true,
      linewidth=2,
      decimals=0,
      lines=false,
      datasource='Prometheus',
      points=false,
      pointradius=5,
      legend_values=true,
      legend_min=true,
      legend_max=true,
      legend_avg=true,
      legend_alignAsTable=true,
      legend_show=true,
      legend_rightSide=false,
      legend_hideZero=false,
      legend_sortDesc=true,
      legend_sort='min',
      editable=true,
      value_type='cumulative',
      formatY1='s',
      formatY2='short',
      logBase1Y=1,
      logBase2Y=1,
      repeat='service',
      repeatDirection='h',
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
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 10,
          },
    )//42 graph
      ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 9,
        },
        style=null,
)//212 row
.addPanel(
    row.new(
      title='Galera Replication Queues',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
      '$service',//title
      description='Shows the length of receive and send queues.',
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
      legend_show=true,
      editable=true,
      value_type='cumulative',
      format='short',
      logBase1Y=1,
      logBase2Y=1,
      repeat='service',
      repeatDirection='h',
      )
      .addTarget(
        prometheus.target(
        'max_over_time(mysql_global_status_wsrep_local_recv_queue{service_name=~"$service"}[$interval]) or
        max_over_time(mysql_global_status_wsrep_local_recv_queue{service_name=~"$service"}[5m])',
        intervalFactor = 1,
        legendFormat='Receive Queue',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
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
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 11,
          },
    )//39 graph
      ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 10,
        },
        style=null,
)//289 row
.addPanel(
    row.new(
      title='Galera Flow Control',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        '$service',//title
        description='Shows the number of FC_PAUSE events sent/received. They are sent by a node when its replication queue gets too full. If a node is sending out FC messages it indicates a problem.',
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
        legend_show=true,
        editable=true,
        value_type='cumulative',
        formatY1='short',
        formatY2='percentunit',
        logBase1Y=1,
        logBase2Y=1,
        repeat='service',
        repeatDirection='h',
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
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 12,
          },
    )//45 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 11,
        },
        style=null,
)//291 row
.addPanel(
    row.new(
      title='Galera Writing Conflicts',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        '$service',//title
        description='Shows the number of local transactions being committed on this node that failed certification (some other node had a commit that conflicted with ours) – client received deadlock error on commit and also the number of local transactions in flight on this node that were aborted because they locked something an applier thread needed – deadlock error anywhere in an open transaction. Spikes in the graph may indicate writing to the same table potentially the same rows from 2 nodes.',
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
        legend_show=true,
        editable=true,
        value_type='cumulative',
        format='ops',
        logBase1Y=1,
        logBase2Y=1,
        repeat='service',
        repeatDirection='h',
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
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 13,
          },
    )//41 graph
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 12,
        },
        style=null,
)//293 row
.addPanel(
    row.new(
      title='Galera Writeset Count',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        '$service',//title
        description='Shows the count of transactions received from the cluster (any other node) and replicated to the cluster (from this node).',
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
        legend_show=true,
        editable=true,
        value_type='cumulative',
        format='short',
        logBase1Y=1,
        logBase2Y=1,
        repeat='service',
        repeatDirection='h',
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
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 14,
          },
    )//2 graph
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 13
        },
        style=null,
)//295 row
.addPanel(
    row.new(
      title='Galera Writeset Traffic',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        '$service',//title
        description='Shows the bytes of data received from the cluster (any other node) and replicated to the cluster (from this node).',
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
        legend_show=true,
        editable=true,
        formatY1='bytes',
        formatY2='none',
        logBase1Y=1,
        logBase2Y=1,
        repeat='service',
        repeatDirection='h',
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
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 15,
          },
    )//9 graph
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 14,
        },
        style=null,
)//297 row
.addPanel(
    row.new(
      title='Galera Parallelization Efficiency',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        '$service',//title
        description='Shows the average distances between highest and lowest seqno that are concurrently applied, committed and can be possibly applied in parallel (potential degree of parallelization).',
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
        legend_show=true,
        editable=true,
        format='short',
        logBase1Y=1,
        logBase2Y=1,
        repeat='service',
        repeatDirection='h',
        value_type='cumulative',
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
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 16,
          },
    )//40 graph
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 15,
        },
        style=null,
)//415 row
.addPanel(
    row.new(
      title='Available Downtime before SST Required',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        '$service',//title
        description='Shows for how long the node can be taken out of the cluster before SST is required. SST is a full state transfer method.',
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
        legend_show=true,
        editable=true,
        formatY1='s',
        formatY2='short',
        logBase1Y=1,
        logBase2Y=1,
        repeat='service',
        repeatDirection='h',
        value_type='cumulative',
      )
      .addTarget(
        prometheus.target(
        'mysql_galera_gcache_size_bytes{service_name=~"$service"}/(rate(mysql_global_status_wsrep_replicated_bytes{service_name=~"$service"}[5m])+rate(mysql_global_status_wsrep_received_bytes{service_name=~"$service"}[5m])) * 300',
        intervalFactor = 1,
        legendFormat='Time (5m avg)',
        refId='A',
        interval='5m',
        calculatedInterval='2m',
        step=300,
        )
      ),gridPos={
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 17,
          }
    )//47 graph
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 16,
        },
        style=null,
)//417 row
.addPanel(
    row.new(
      title='Galera Writeset Size',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        '$service',//title
        description='Shows the average transaction size received/replicated.',
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
        legend_show=true,
        editable=true,
        formatY1='bytes',
        formatY2='short',
        logBase1Y=1,
        logBase2Y=1,
        repeat='service',
        repeatDirection='h',
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
          'rate(mysql_global_status_wsrep_replicated_bytes{service_name=~\"$service\"}[$interval]) / rate(mysql_global_status_wsrep_replicated{service_name=~\"$service\"}[$interval]) or irate(mysql_global_status_wsrep_replicated_bytes{service_name=~\"$service\"}[5m]) / irate(mysql_global_status_wsrep_replicated{service_name=~\"$service\"}[5m])',
          intervalFactor = 1,
          legendFormat='Replicating Transaction Size',
          refId='A',
          interval='$interval',
          calculatedInterval='2m',
          step=300,
          )
      ),gridPos={
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 18,
          }
    )//11 graph
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 17,
        },
        style=null,
)//419 row
.addPanel(
    row.new(
      title='Galera Network Usage Hourly',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        '$service',//title
        description='Shows the bytes of data received from the cluster (any other node) and replicated to the cluster (from this node).',
        fill=6,
        linewidth=2,
        decimals=0,
        lines=false,
        bars=true,
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
        formatY1='bytes',
        formatY2='none',
        logBase1Y=1,
        logBase2Y=1,
        repeat='service',
        repeatDirection='h',
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
          "x": 0,
          "y": 19,
          }
    )//38 graph
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 18,
        },
        style=null,
)//421 row
