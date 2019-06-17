local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local template = grafana.template;
local prometheus = grafana.prometheus;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local row = grafana.row;
local singlestat = grafana.singlestat;
local tablePanel = grafana.tablePanel;


dashboard.new(
  'Network Overview',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  style='dark',
  uid='000000193',
  version=1,
  iteration=1553886652179,
  tags=['Percona','OS'],
  description='Network Overview',
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
  'host',
  'Prometheus',
  'label_values(node_boot_time_seconds, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  definition='label_values(node_boot_time_seconds, node_name)',
  ),
)
.addTemplate(
  template.new(
  'device',
  'Prometheus',
  'label_values(node_network_receive_packets_total{node_name=~"$host"},device)',
  label='Device',
  refresh='load',
  sort=1,
  multi=true,
  includeAll=true,
  ),
)
.addPanel(
    row.new(
      title='Last Hour statistic',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 0,
    },
    style=null,
)//51 row
.addPanel(
  singlestat.new(
    'Inbound Speed',//title
    format='Bps',
    datasource='Prometheus',
    thresholds='',
  )
  .addTarget(
    prometheus.target(
      'sum(rate(node_network_receive_bytes_total{device!="lo",node_name=~"$host"}[1h]))',
      intervalFactor = 1,
      refId='A',
    )
  ),
  gridPos = {
      "h": 2,
      "w": 6,
      "x": 0,
      "y": 1,
  },
  style=null,
)//53 singlestat
.addPanel(
  singlestat.new(
    'Outbound Speed',//title
    format='Bps',
    datasource='Prometheus',
    thresholds='',
  )
  .addTarget(
    prometheus.target(
      'sum(rate(node_network_transmit_bytes_total{device!="lo",node_name=~"$host"}[1h]))',
      intervalFactor = 1,
      refId='A',
    )
  ),
  gridPos = {
      "h": 2,
      "w": 6,
      "x": 6,
      "y": 1,
  },
  style=null,
)//55 singlestat
.addPanel(
  singlestat.new(
    'Traffic Errors and Drops',//title
    format='short',
    datasource='Prometheus',
    thresholds='0.9,10',
    valueName='current',
    colorValue=true,
  )
  .addTarget(
    prometheus.target(
      'sum(increase(node_network_receive_errs_total{node_name=~"$host", device!="lo"}[1h])) +
      sum(increase(node_network_transmit_errs_total{node_name=~"$host", device!="lo"}[1h])) +
      sum(increase(node_network_receive_drop_total{node_name=~"$host", device!="lo"}[1h])) +
      sum(increase(node_network_transmit_drop_total{node_name=~"$host", device!="lo"}[1h]))',
      intervalFactor = 1,
      interval='$interval',
      refId='A',
    )
  ),
  gridPos = {
      "h": 2,
      "w": 6,
      "x": 12,
      "y": 1,
  },
  style=null,
)//57 singlestat
.addPanel(
  singlestat.new(
    'Retransmit rate',//title
    format='percent',
    datasource='Prometheus',
    thresholds='0.1,10',
    valueName='current',
    colorValue=true,
  )
  .addTarget(
    prometheus.target(
      'rate(node_netstat_Tcp_RetransSegs{node_name=~"$host"}[1h]) * 100 / (rate(node_netstat_Tcp_OutSegs{node_name=~"$host"}[1h]) + rate(node_netstat_Tcp_InSegs{node_name=~"$host"}[1h]))',
      intervalFactor = 1,
      interval='$interval',
      hide=false,
      refId='A',
    )
  ),
  gridPos = {
    "h": 2,
    "w": 6,
    "x": 18,
    "y": 1,
  },
  style=null,
)//59 singlestat
.addPanel(
    row.new(
      title='Network Traffic',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 3,
    },
    style=null,
)//45 row
.addPanel(
  graphPanel.new(
  'Network Traffic',//title
  fill=2,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=true,
  points=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_sort='avg',
  legend_sortDesc=true,
  editable=true,
  formatY1='bytes',
  formatY2 = 'short',
  value_type='cumulative',
  nullPointMode='connected',
  )
  .addSeriesOverride(
    {
      "alias": "Outbound",
      "transform": "negative-Y"
    }
  )
  .addTarget(
    prometheus.target(
    'sum(rate(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[$interval])) or
    sum(irate(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[5m])) or
    sum(max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[$interval])) or
    sum(max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[5m]))',
    intervalFactor = 1,
    legendFormat='Inbound',
    refId='C',
    interval='$interval',
    )
    )
  .addTarget(
      prometheus.target(
      'sum(rate(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[$interval])) or
      sum(irate(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[5m])) or
      sum(max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[$interval])) or
      sum(max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[5m]))',
      intervalFactor = 1,
      legendFormat='Outbound',
      refId='A',
      interval='$interval',
      hide=false,
      )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 4,
  },style=null,
)//12 graph
.addPanel(
  graphPanel.new(
    'Network Utilization Hourly',//title
    fill=1,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    bars=true,
    lines=false,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    formatY1='bytes',
    formatY2 = 'short',
    value_type='cumulative',
    stack=true,
    nullPointMode='connected',
  )
  .addTarget(
    prometheus.target(
    'sum(increase(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[1h]))',
    intervalFactor = 1,
    legendFormat='Inbound',
    refId='A',
    interval='1h',
    step=40,
    )
    )
  .addTarget(
      prometheus.target(
      'sum(increase(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[1h]))',
      intervalFactor = 1,
      legendFormat='Outbound',
      refId='B',
      interval='1h',
      step=40,
      )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 4,
  },style=null,
)//24 graph
.addPanel(
    row.new(
      title='Network traffic details',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 11,
    },
    style=null,
)//46 row
.addPanel(
  graphPanel.new(
    'Network Traffic by Packets',//title
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    lines=true,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_rightSide=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    formatY1='pps',
    formatY2 = 'short',
  )
  .addSeriesOverride(
      {
        "alias": "/.*Trans.*/",
        "transform": "negative-Y"
      }
   )
  .addTarget(
    prometheus.target(
    'rate(node_network_receive_packets_total{node_name=~"$host", device!="lo"}[$interval]) or
    irate(node_network_receive_packets_total{node_name=~"$host", device!="lo"}[5m])',
    intervalFactor = 1,
    legendFormat='{{device}} - Receive',
    refId='A',
    interval='$interval',
    )
    )
  .addTarget(
      prometheus.target(
      'rate(node_network_transmit_packets{node_name=~"$host", device!="lo"}[$interval]) or
      irate(node_network_transmit_packets{node_name=~"$host", device!="lo"}[5m])',
      intervalFactor = 1,
      legendFormat='{{device}} - Transmit',
      refId='B',
      interval='$interval',
      )
  ),gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 12,
  },style=null,
)//28 graph
.addPanel(
  graphPanel.new(
    'Network Traffic Errors',//title
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    lines=true,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    format = 'short',
    maxPerRow=2,
    paceLength=10,
  )
  .addTarget(
    prometheus.target(
    'rate(node_network_receive_errs_total{node_name=~"$host", device!="lo"}[$interval]) or
    irate(node_network_receive_errs_total{node_name=~"$host", device!="lo"}[5m])',
    intervalFactor = 1,
    legendFormat='{{device}} - Receive errors',
    refId='A',
    interval='$interval',
    )
    )
  .addTarget(
      prometheus.target(
      'rate(node_network_transmit_errs_total{node_name=~"$host", device!="lo"}[$interval]) or
      irate(node_network_transmit_errs_total{node_name=~"$host", device!="lo"}[5m])',
      intervalFactor = 1,
      legendFormat='{{device}} - Transmit errors',
      refId='B',
      interval='$interval',
      )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 19,
  },style=null,
)//29 graph
.addPanel(
  graphPanel.new(
    'Network Traffic Drop',//title
    fill=1,
    linewidth=1,
    datasource='Prometheus',
    pointradius=5,
    lines=true,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    format = 'short',
    maxPerRow=2,
    paceLength=10,
  )
  .addTarget(
    prometheus.target(
    'rate(node_network_receive_drop_total{node_name=~"$host", device!="lo"}[$interval]) or
    irate(node_network_receive_drop_total{node_name=~"$host", device!="lo"}[5m])',
    intervalFactor = 1,
    legendFormat='{{device}} - Receive drop',
    refId='A',
    interval='$interval',
    )
    )
  .addTarget(
      prometheus.target(
      'rate(node_network_transmit_drop_total{node_name=~"$host", device!="lo"}[$interval]) or
      irate(node_network_transmit_drop_total{node_name=~"$host", device!="lo"}[5m])',
      intervalFactor = 1,
      legendFormat='{{device}} - Transmit drop',
      refId='B',
      interval='$interval',
      )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 19,
  },style=null,
)//30 graph
.addPanel(
  graphPanel.new(
    'Network Traffic Multicast',//title
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    lines=true,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_rightSide=true,
    editable=true,
    formatY1='pps',
    formatY2 = 'short',
    maxPerRow=1,
    paceLength=10,
  )
  .addTarget(
    prometheus.target(
    'rate(node_network_receive_multicast_total{node_name=~"$host", device!="lo"}[$interval]) or
    irate(node_network_receive_multicast_total{node_name=~"$host", device!="lo"}[5m])',
    intervalFactor = 1,
    legendFormat='{{device}} - Receive multicast',
    refId='A',
    interval='$interval',
    )
    )
  .addTarget(
      prometheus.target(
      'rate(node_network_transmit_multicast_total{node_name=~"$host", device!="lo"}[$interval]) or
      irate(node_network_transmit_multicast_total{node_name=~"$host", device!="lo"}[5m])',
      intervalFactor = 1,
      legendFormat='{{device}} - Transmit multicast',
      refId='B',
      interval='$interval',
      )
  ),gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 26,
  },style=null,
)//32 graph
.addPanel(
    row.new(
      title='Network Netstat TCP',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 33,
    },
    style=null,
)//47 row
.addPanel(
  singlestat.new(
    'Timeout value used for retransmitting',//title
    format='ms',
    datasource='Prometheus',
    thresholds='',
    valueName='current',
    height='125px',
  )
  .addTarget(
    prometheus.target(
      'node_netstat_Tcp_RtoAlgorithm{node_name=~"$host"}',
      intervalFactor = 1,
      interval='$interval',
      refId='A',
    )
  ),
  gridPos = {
      "h": 2,
      "w": 8,
      "x": 0,
      "y": 34,
  },
  style=null,
)//36 singlestat
.addPanel(
  singlestat.new(
    'Min TCP Retransmission timeout',//title
    format='ms',
    datasource='Prometheus',
    thresholds='',
    valueName='min',
    height='125px',
  )
  .addTarget(
    prometheus.target(
      'min_over_time(node_netstat_Tcp_RtoMin{node_name=~"$host"}[$interval])',
      intervalFactor = 1,
      interval='$interval',
      refId='A',
    )
  ),
  gridPos = {
      "h": 2,
      "w": 8,
      "x": 8,
      "y": 34,
  },
  style=null,
)//38 singlestat
.addPanel(
  singlestat.new(
    'Max TCP Retransmission timeout',//title
    format='ms',
    datasource='Prometheus',
    thresholds='',
    valueName='current',
    height='125px',
    maxPerRow=3,
  )
  .addTarget(
    prometheus.target(
      'max_over_time(node_netstat_Tcp_RtoMax{node_name=~"$host"}[$interval])',
      intervalFactor = 1,
      interval='$interval',
      refId='A',
    )
  ),
  gridPos = {
      "h": 2,
      "w": 8,
      "x": 16,
      "y": 34,
  },
  style=null,
)//37 singlestat
.addPanel(
  graphPanel.new(
    'Netstat: TCP',//title
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    lines=true,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_rightSide=true,
    editable=true,
    format = 'short',
    value_type='cumulative',
    maxPerRow=1,
    paceLength=10,
    nullPointMode='connected',
  )
  .addTarget(
    prometheus.target(
    'max_over_time(node_netstat_Tcp_CurrEstab{node_name=~"$host"}[$interval]) or
    max_over_time(node_netstat_Tcp_CurrEstab{node_name=~"$host"}[5m])',
    intervalFactor = 1,
    legendFormat='established',
    refId='A',
    interval='$interval',
    step=40,
    )
    )
  .addTarget(
      prometheus.target(
      'max_over_time(node_netstat_Tcp_ActiveOpens{node_name=~"$host"}[$interval]) or
      max_over_time(node_netstat_Tcp_ActiveOpens{node_name=~"$host"}[5m])',
      intervalFactor = 1,
      legendFormat='activeOpens',
      refId='B',
      interval='$interval',
      step=40,
      )
      )
  .addTarget(
        prometheus.target(
        'max_over_time(node_netstat_Tcp_PassiveOpens{node_name=~"$host"}[$interval]) or
        max_over_time(node_netstat_Tcp_PassiveOpens{node_name=~"$host"}[5m])',
        intervalFactor = 1,
        legendFormat='passiveOpens',
        refId='C',
        interval='$interval',
        step=40,
        )
        )
  .addTarget(
          prometheus.target(
          'max_over_time(node_netstat_Tcp_EstabResets{node_name=~"$host"}[$interval]) or
          max_over_time(node_netstat_Tcp_EstabResets{node_name=~"$host"}[5m])',
          intervalFactor = 1,
          legendFormat='estabResets',
          refId='D',
          interval='$interval',
          step=40,
          )
          )
  .addTarget(
            prometheus.target(
            'max_over_time(node_netstat_Tcp_AttemptFails{node_name=~"$host"}[$interval]) or
            max_over_time(node_netstat_Tcp_AttemptFails{node_name=~"$host"}[5m])',
            intervalFactor = 1,
            legendFormat='attemptfails',
            refId='E',
            interval='$interval',
            step=40,
            )
            )
  .addTarget(
      prometheus.target(
      'max_over_time(node_netstat_Tcp_RetransSegs{node_name=~"$host"}[$interval]) or
      max_over_time(node_netstat_Tcp_RetransSegs{node_name=~"$host"}[5m])',
      intervalFactor = 1,
      legendFormat='retransSegs',
      refId='F',
      interval='$interval',
      )
  ),gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 36,
  },style=null,
)//21 graph
.addPanel(
  graphPanel.new(
    'TCP Segments',//title
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    lines=true,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_rightSide=true,
    editable=true,
    format = 'short',
    maxPerRow=1,
    paceLength=10,
  )
  .addSeriesOverride(
    {
     "alias": "/.*Out.*/",
     "transform": "negative-Y"
    }
  )
  .addTarget(
    prometheus.target(
    'rate(node_netstat_Tcp_InCsumErrors{node_name=~"$host"}[$interval]) or irate(node_netstat_Tcp_InCsumErrors{node_name=~"$host"}[5m])',
    intervalFactor = 1,
    legendFormat='InCsumErrors',
    refId='A',
    interval='$interval',
    )
    )
  .addTarget(
      prometheus.target(
      'rate(node_netstat_Tcp_InErrs{node_name=~"$host"}[$interval]) or irate(node_netstat_Tcp_InErrs{node_name=~"$host"}[5m])',
      intervalFactor = 1,
      legendFormat='InErrs',
      refId='B',
      interval='$interval',
      )
      )
  .addTarget(
        prometheus.target(
        'rate(node_netstat_Tcp_InSegs{node_name=~"$host"}[$interval]) or irate(node_netstat_Tcp_InSegs{node_name=~"$host"}[5m])',
        intervalFactor = 1,
        legendFormat='InSegs',
        refId='C',
        interval='$interval',
        )
        )
  .addTarget(
          prometheus.target(
          'rate(node_netstat_Tcp_OutRsts{node_name=~"$host"}[$interval]) or irate(node_netstat_Tcp_OutRsts{node_name=~"$host"}[5m])',
          intervalFactor = 1,
          legendFormat='OutRsts',
          refId='D',
          interval='$interval',
          )
          )
  .addTarget(
            prometheus.target(
            'rate(node_netstat_Tcp_OutSegs{node_name=~"$host"}[$interval]) or irate(node_netstat_Tcp_OutSegs{node_name=~"$host"}[5m])',
            intervalFactor = 1,
            legendFormat='OutSegs',
            refId='E',
            interval='$interval',
            )
            )
  .addTarget(
      prometheus.target(
      'rate(node_netstat_Tcp_RetransSegs{node_name=~"$host"}[$interval]) or irate(node_netstat_Tcp_RetransSegs{node_name=~"$host"}[5m])',
      intervalFactor = 1,
      legendFormat='RetransSegs',
      refId='F',
      interval='$interval',
      )
  ),gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 43,
  },style=null,
)//35 graph
.addPanel(
    row.new(
      title='Network Netstat UDP',
    ),
    gridPos={
      "h": 1,
     "w": 24,
     "x": 0,
     "y": 50,
    },
    style=null,
)//48 row
.addPanel(
  graphPanel.new(
    'Netstat: UDP',//title
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    lines=true,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_rightSide=true,
    editable=true,
    formatY1 = 'short',
    formatY2='bytes',
    maxPerRow=1,
    paceLength=10,
    value_type='cumulative',
    nullPointMode='connected',
  )
  .addSeriesOverride(
    {
        "alias": "/.*Out.*/",
        "transform": "negative-Y"
    }
   )
  .addSeriesOverride(
    {
        "alias": "Udp_NoPorts",
        "yaxis": 2
      }
    )
  .addTarget(
    prometheus.target(
    'sum(rate(node_netstat_Udp_InDatagrams{node_name=~"$host"}[$interval]) or irate(node_netstat_Udp_InDatagrams{node_name=~"$host"}[5m]))',
    intervalFactor = 1,
    legendFormat='Udp_InDatagrams',
    refId='A',
    interval='$interval',
    step=40,
    )
    )
  .addTarget(
      prometheus.target(
      'sum(rate(node_netstat_Udp_InErrors{node_name=~"$host"}[$interval]) or irate(node_netstat_Udp_InErrors{node_name=~"$host"}[5m]))',
      intervalFactor = 1,
      legendFormat='Udp_InErrors',
      refId='B',
      interval='$interval',
      step=40,
      )
      )
  .addTarget(
        prometheus.target(
        'sum(rate(node_netstat_Udp_OutDatagrams{node_name=~"$host"}[$interval]) or irate(node_netstat_Udp_OutDatagrams{node_name=~"$host"}[5m]))',
        intervalFactor = 1,
        legendFormat='Udp_OutDatagrams',
        refId='C',
        interval='$interval',
        step=40,
        )
        )
  .addTarget(
          prometheus.target(
          'sum(rate(node_netstat_Udp_NoPorts{node_name=~"$host"}[$interval]) or irate(node_netstat_Udp_NoPorts{node_name=~"$host"}[5m]))',
          intervalFactor = 1,
          legendFormat='Udp_NoPorts',
          refId='D',
          interval='$interval',
          step=40,
          )
          )
  .addTarget(
            prometheus.target(
            'sum(rate(node_netstat_Udp_InCsumErrors{node_name=~"$host"}[$interval]) or irate(node_netstat_Udp_InCsumErrors{node_name=~"$host"}[5m]))',
            intervalFactor = 1,
            legendFormat='Udp_InCsumErrors',
            refId='E',
            interval='$interval',
            step=40,
            )
            )
  .addTarget(
      prometheus.target(
      'sum(rate(node_netstat_Udp_RcvbufErrors{node_name=~"$host"}[$interval]) or irate(node_netstat_Udp_RcvbufErrors{node_name=~"$host"}[5m]))',
      intervalFactor = 1,
      legendFormat='Udp_RcvbufErrors',
      refId='F',
      interval='$interval',
      step=40,
      )
      )
  .addTarget(
          prometheus.target(
          'sum(rate(node_netstat_Udp_SndbufErrors{node_name=~"$node"}[$interval]) or irate(node_netstat_Udp_SndbufErrors{node_name=~"$host"}[5m]))',
          intervalFactor = 1,
          legendFormat='Udp_SndbufErrors',
          refId='G',
          interval='$interval',
          step=40,
          )
  ),gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 51,
  },style=null,
)//23 graph
.addPanel(
  graphPanel.new(
    'UDP Lite',//title
    fill=1,
    linewidth=1,
    datasource='Prometheus',
    description='**InDatagrams** Packets received

    **OutDatagrams** Packets sent

    **InCsumErrors** Datagrams with checksum errors

    **InErrors** Datagrams that could not be delivered to an application

    **RcvbufErrors** Datagrams for which not enough socket buffer memory to receive

    **SndbufErrors**  Datagrams for which not enough socket buffer memory to transmit

    **NoPorts**  Datagrams received on a port with no listener',
    pointradius=5,
    lines=true,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_rightSide=true,
    editable=true,
    formatY2 = 'short',
    formatY1='ops',
    paceLength=10,
  )
  .addSeriesOverride(
      {
        "alias": "/.*Out.*/",
        "transform": "negative-Y"
      }
    )
  .addTarget(
    prometheus.target(
    'rate(node_netstat_UdpLite_InDatagrams{node_name=~"$host"}[$interval]) or
    irate(node_netstat_UdpLite_InDatagrams{node_name=~"$host"}[5m])',
    intervalFactor = 1,
    legendFormat='InDatagrams',
    refId='A',
    interval='$interval',
    )
    )
  .addTarget(
      prometheus.target(
      'rate(node_netstat_UdpLite_OutDatagrams{node_name=~"$host"}[$interval]) or
      irate(node_netstat_UdpLite_OutDatagrams{node_name=~"$host"}[5m])',
      intervalFactor = 1,
      legendFormat='OutDatagrams',
      refId='B',
      interval='$interval',
      )
      )
  .addTarget(
        prometheus.target(
        'rate(node_netstat_UdpLite_InCsumErrors{node_name=~"$host"}[$interval]) or
        irate(node_netstat_UdpLite_InCsumErrors{node_name=~"$host"}[5m])',
        intervalFactor = 1,
        legendFormat='InCsumErrors',
        refId='C',
        interval='$interval',
        )
        )
  .addTarget(
          prometheus.target(
          'rate(node_netstat_UdpLite_InErrors{node_name=~"$host"}[$interval]) or
          irate(node_netstat_UdpLite_InErrors{node_name=~"$host"}[5m])',
          intervalFactor = 1,
          legendFormat='InErrors',
          refId='D',
          interval='$interval',
          )
          )
  .addTarget(
            prometheus.target(
            'rate(node_netstat_UdpLite_RcvbufErrors{node_name=~"$host"}[$interval]) or
            irate(node_netstat_UdpLite_RcvbufErrors{node_name=~"$host"}[5m])',
            intervalFactor = 1,
            legendFormat='RcvbufErrors',
            refId='E',
            interval='$interval',
            )
            )
  .addTarget(
      prometheus.target(
      'rate(node_netstat_UdpLite_SndbufErrors{node_name=~"$host"}[$interval]) or
      irate(node_netstat_UdpLite_SndbufErrors{node_name=~"$host"}[5m])',
      intervalFactor = 1,
      legendFormat='SndbufErrors',
      refId='F',
      interval='$interval',
      )
      )
  .addTarget(
          prometheus.target(
          'rate(node_netstat_UdpLite_NoPorts{node_name=~"$host"}[$interval]) or
          irate(node_netstat_UdpLite_NoPorts{node_name=~"$host"}[5m])',
          intervalFactor = 1,
          legendFormat='NoPorts',
          refId='G',
          interval='$interval',
          )
  ),gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 58,
  },style=null,
)//43 graph
.addPanel(
    row.new(
      title='ICMP',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 65,
    },
    style=null,
)//49 row
.addPanel(
  graphPanel.new(
    'ICMP Errors',//title
    fill=2,
    decimals=2,
    linewidth=2,
    datasource='Prometheus',
    description='**InErrors**  Messages which the entity received but determined as having ICMP-specific errors (bad ICMP checksums, bad length, etc.)

    **OutErrors** Messages which this entity did not send due to problems discovered within ICMP, such as a lack of buffers

    **InDestUnreachs**  Destination Unreachable messages received

    **OutDestUnreachs** Destination Unreachable messages sent

    **InType3** Destination unreachable

    **OutType3** Destination unreachable

    **InCsumErrors** Messages with ICMP checksum errors

    **InTimeExcds** Time Exceeded messages received',
    pointradius=5,
    lines=false,
    bars=true,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_rightSide=true,
    editable=true,
    formatY2 = 'short',
    formatY1='ops',
    paceLength=10,
    stack=true,
    maxPerRow=1,
  )
  .addSeriesOverride(
      {
        "alias": "/.*Out.*/",
        "transform": "negative-Y"
      }
    )
  .addTarget(
    prometheus.target(
    'rate(node_netstat_Icmp_InErrors{node_name=~"$host"}[$interval])
    or irate(node_netstat_Icmp_InErrors{node_name=~"$host"}[5m])',
    intervalFactor = 1,
    legendFormat='InErrors',
    refId='A',
    interval='$interval',
    )
    )
  .addTarget(
      prometheus.target(
      'rate(node_netstat_Icmp_OutErrors{node_name=~"$host"}[$interval]) or
      irate(node_netstat_Icmp_OutErrors{node_name=~"$host"}[5m])',
      intervalFactor = 1,
      legendFormat='OutErrors',
      refId='B',
      interval='$interval',
      )
      )
  .addTarget(
        prometheus.target(
        'rate(node_netstat_Icmp_InDestUnreachs{node_name=~"$host"}[$interval]) or
        irate(node_netstat_Icmp_InDestUnreachs{node_name=~"$host"}[5m])',
        intervalFactor = 1,
        legendFormat='InDestUnreachs',
        refId='C',
        interval='$interval',
        )
        )
  .addTarget(
          prometheus.target(
          'rate(node_netstat_Icmp_OutDestUnreachs{node_name=~"$host"}[$interval]) or
          irate(node_netstat_Icmp_OutDestUnreachs{node_name=~"$host"}[5m])',
          intervalFactor = 1,
          legendFormat='OutDestUnreachs',
          refId='D',
          interval='$interval',
          )
          )
  .addTarget(
            prometheus.target(
            'rate(node_netstat_IcmpMsg_InType3{node_name=~"$host"}[$interval]) or
            irate(node_netstat_IcmpMsg_InType3{node_name=~"$host"}[5m])',
            intervalFactor = 1,
            legendFormat='InType3 (Destination unreachable)',
            refId='E',
            interval='$interval',
            )
            )
  .addTarget(
      prometheus.target(
      'irate(node_netstat_IcmpMsg_OutType3{node_name=~"$host"}[$interval]) or
      irate(node_netstat_IcmpMsg_OutType3{node_name=~"$host"}[5m])',
      intervalFactor = 1,
      legendFormat='OutType3 (Destination unreachable)',
      refId='F',
      interval='$interval',
      )
      )
  .addTarget(
          prometheus.target(
          'rate(node_netstat_Icmp_InCsumErrors{node_name=~"$host"}[$interval]) or
          irate(node_netstat_Icmp_InCsumErrors{node_name=~"$host"}[5m])',
          intervalFactor = 1,
          legendFormat='InCsumErrors',
          refId='G',
          interval='$interval',
          )
      )
  .addTarget(
              prometheus.target(
              'rate(node_netstat_Icmp_InTimeExcds{node_name=~"$host"}[$interval]) or
              irate(node_netstat_Icmp_InTimeExcds{node_name=~"$host"}[5m])',
              intervalFactor = 1,
              legendFormat='InTimeExcds',
              refId='H',
              interval='$interval',
              )
  ),gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 66,
  },style=null,
)//39 graph
.addPanel(
  graphPanel.new(
    'Messages / Redirects',//title
    fill=1,
    decimals=2,
    linewidth=1,
    datasource='Prometheus',
    description='**InMsgs**  Messages which the entity received. Note that this counter includes all those counted by icmpInErrors

    **InRedirects**  Redirect messages received

    **OutMsgs**  Messages which this entity attempted to send. Note that this counter includes all those counted by icmpOutErrors

    **OutRedirects** Redirect messages sent. For a host, this object will always be zero, since hosts do not send redirects',
    pointradius=5,
    lines=false,
    bars=true,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_rightSide=true,
    editable=true,
    formatY2 = 'short',
    formatY1='ops',
    paceLength=10,
    maxPerRow=1,
  )
  .addSeriesOverride(
      {
        "alias": "/.*Out.*/",
        "transform": "negative-Y"
      }
    )
  .addTarget(
    prometheus.target(
    'rate(node_netstat_Icmp_InMsgs{node_name=~"$host"}[$interval]) or
    irate(node_netstat_Icmp_InMsgs{node_name=~"$host"}[5m])',
    intervalFactor = 1,
    legendFormat='InMsgs',
    refId='A',
    interval='$interval',
    )
    )
  .addTarget(
      prometheus.target(
      'rate(node_netstat_Icmp_InRedirects{node_name=~"$host"}[$interval]) or
      irate(node_netstat_Icmp_InRedirects{node_name=~"$host"}[5m])',
      intervalFactor = 1,
      legendFormat='InRedirects',
      refId='B',
      interval='$interval',
      )
      )
  .addTarget(
        prometheus.target(
        'rate(node_netstat_Icmp_OutMsgs{node_name=~"$host"}[$interval]) or
        irate(node_netstat_Icmp_OutMsgs{node_name=~"$host"}[5m])',
        intervalFactor = 1,
        legendFormat='OutMsgs',
        refId='C',
        interval='$interval',
        )
        )
  .addTarget(
          prometheus.target(
          'rate(node_netstat_Icmp_OutRedirects{node_name=~"$host"}[$interval]) or
          irate(node_netstat_Icmp_OutRedirects{node_name=~"$host"}[5m])',
          intervalFactor = 1,
          legendFormat='OutRedirects',
          refId='D',
          interval='$interval',
          )
  ),gridPos={
     "h": 7,
     "w": 24,
     "x": 0,
     "y": 73,
  },style=null,
)//41 graph
.addPanel(
  graphPanel.new(
    'Echos',//title
    fill=1,
    decimals=2,
    linewidth=1,
    datasource='Prometheus',
    description='**InEchoReps**  Echo Reply messages received

    **InEchos**  Echo (request) messages received

    **OutEchoReps** Echo Reply messages sent

    **OutEchos**  Echo (request) messages sent',
    pointradius=5,
    lines=false,
    bars=true,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    formatY2 = 'short',
    formatY1='ops',
    paceLength=10,
    maxPerRow=1,
  )
  .addSeriesOverride(
      {
        "alias": "/.*Out.*/",
        "transform": "negative-Y"
      }
    )
  .addTarget(
    prometheus.target(
    'rate(node_netstat_Icmp_InEchoReps{node_name=~"$host"}[$interval]) or
    irate(node_netstat_Icmp_InEchoReps{node_name=~"$host"}[5m])',
    intervalFactor = 1,
    legendFormat='InEchoReps',
    refId='A',
    interval='$interval',
    )
    )
  .addTarget(
      prometheus.target(
      'rate(node_netstat_Icmp_InEchos{node_name=~"$host"}[$interval]) or
      irate(node_netstat_Icmp_InEchos{node_name=~"$host"}[5m])',
      intervalFactor = 1,
      legendFormat='InEchos',
      refId='B',
      interval='$interval',
      )
      )
  .addTarget(
        prometheus.target(
        'rate(node_netstat_Icmp_OutEchoReps{node_name=~"$host"}[$interval]) or
        irate(node_netstat_Icmp_OutEchoReps{node_name=~"$host"}[5m])',
        intervalFactor = 1,
        legendFormat='OutEchoReps',
        refId='C',
        interval='$interval',
        )
        )
  .addTarget(
          prometheus.target(
          'rate(node_netstat_Icmp_OutEchos{node_name=~"$host"}[$interval]) or
          irate(node_netstat_Icmp_OutEchos{node_name=~"$host"}[5m])',
          intervalFactor = 1,
          legendFormat='OutEchos',
          refId='D',
          interval='$interval',
          )
  ),gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 80,
  },style=null,
)//40 graph
.addPanel(
  graphPanel.new(
    'Timestamps / Mask Requests',//title
    fill=1,
    linewidth=1,
    datasource='Prometheus',
    description='**InAddrMaskReps**  Address Mask Reply messages received

    **InAddrMasks** Address Mask Request messages received

    **OutAddrMaskReps**  Address Mask Reply messages sent

    **OutAddrMasks**  Address Mask Request messages sent

    **InTimestampReps**  Timestamp Reply messages received

    **InTimestamps**  Timestamp Request messages received

    **OutTimestampReps** Timestamp Reply messages sent

    **OutTimestamps** Timestamp Request messages sent',
    pointradius=5,
    lines=false,
    bars=true,
    points=false,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    format = 'short',
    paceLength=10,
    maxPerRow=2,
    stack=true,
  )
  .addSeriesOverride(
      {
        "alias": "/.*Out.*/",
        "transform": "negative-Y"
      }
    )
  .addTarget(
    prometheus.target(
    'rate(node_netstat_Icmp_InAddrMaskReps{node_name=~"$host"}[$interval]) or
    irate(node_netstat_Icmp_InAddrMaskReps{node_name=~"$host"}[5m])',
    intervalFactor = 1,
    legendFormat='InAddrMaskReps',
    refId='A',
    interval='$interval',
    )
    )
  .addTarget(
      prometheus.target(
      'rate(node_netstat_Icmp_InAddrMasks{node_name=~"$host"}[$interval]) or
      irate(node_netstat_Icmp_InAddrMasks{node_name=~"$host"}[5m])',
      intervalFactor = 1,
      legendFormat='InAddrMasks',
      refId='B',
      interval='$interval',
      )
      )
  .addTarget(
        prometheus.target(
        'rate(node_netstat_Icmp_OutAddrMaskReps{node_name=~"$host"}[$interval]) or
        irate(node_netstat_Icmp_OutAddrMaskReps{node_name=~"$host"}[5m])',
        intervalFactor = 1,
        legendFormat='OutAddrMaskReps',
        refId='C',
        interval='$interval',
        )
        )
  .addTarget(
          prometheus.target(
          'rate(node_netstat_Icmp_OutAddrMasks{node_name=~"$host"}[5m]) or
          irate(node_netstat_Icmp_OutAddrMasks{node_name=~"$host"}[5m])',
          intervalFactor = 1,
          legendFormat='OutAddrMasks',
          refId='D',
          interval='$interval',
          )
          )
  .addTarget(
                  prometheus.target(
                  'rate(node_netstat_Icmp_InTimestampReps{node_name=~"$host"}[$interval]) or
                  irate(node_netstat_Icmp_InTimestampReps{node_name=~"$host"}[5m])',
                  intervalFactor = 1,
                  legendFormat='InTimestampReps',
                  refId='E',
                  interval='$interval',
                  )
                  )
  .addTarget(
                          prometheus.target(
                          'rate(node_netstat_Icmp_InTimestamps{node_name=~"$host"}[$interval]) or
                          irate(node_netstat_Icmp_InTimestamps{node_name=~"$host"}[5m])',
                          intervalFactor = 1,
                          legendFormat='InTimestamps',
                          refId='F',
                          interval='$interval',
                          )
                          )
  .addTarget(
                                  prometheus.target(
                                  'rate(node_netstat_Icmp_OutTimestampReps{node_name=~"$host"}[$interval]) or
                                  irate(node_netstat_Icmp_OutTimestampReps{node_name=~"$host"}[5m])',
                                  intervalFactor = 1,
                                  legendFormat='OutTimestampReps',
                                  refId='G',
                                  interval='$interval',
                                  )
                                  )
  .addTarget(
                                          prometheus.target(
                                          'rate(node_netstat_Icmp_OutTimestamps{node_name=~"$host"}[$interval]) or
                                          irate(node_netstat_Icmp_OutTimestamps{node_name=~"$host"}[5m])',
                                          intervalFactor = 1,
                                          legendFormat='OutTimestamps',
                                          refId='H',
                                          interval='$interval',
                                          )
  ),gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 80,
  },style=null,
)//42 graph
