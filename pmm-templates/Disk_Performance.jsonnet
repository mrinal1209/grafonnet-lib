local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local text = grafana.text;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;

dashboard.new(
  'Disk Performance',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=16,
  version=1,
  tags=['OS','Percona'],
  iteration=1535393643104,
  uid="oxkrQMNmz",
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
  'host',
  'Prometheus',
  'label_values({__name__=~"node_disk_reads_completed_total|aws_rds_disk_queue_depth_average|rdsosmetrics_diskIO_readLatency"}, node_name)',
  label='Host',
  tagValuesQuery='instance',
  refresh='load',
  sort=1,
  tagsQuery='up',
  refresh_on_load=false,
  allFormat='glob',
  multiFormat='regex values'
  ),
)
.addTemplate(
  template.new(
  'device',
  'Prometheus',
  'label_values(node_disk_reads_completed_total{node_name="$host", device!~"dm-.+"}, device)',
  label='Device',
  tagValuesQuery='instance',
  refresh='load',
  sort=1,
  tagsQuery='up',
  refresh_on_load=false,
  allFormat='glob',
  multiFormat='regex values',
  multi=true,
  includeAll=true,
  ),
)
.addPanel(
  text.new(
  content='You can click on an individual disk device on the legend to filter on it or multiple ones by holding Alt button.',
  datasource='Prometheus',
  editable=true,
  //error=false,
  height='50px',
  id=8,
  transparent=true,
  ),gridPos={
  x: 0,
  y: 0,
  w: 24,
  h: 3,
},style={},
)
.addPanel(
  graphPanel.new(
  'Disk Latency',//title
  fill=2,
  linewidth=2,
  decimals=2,
  description='Shows average latency for Reads and Writes IO Devices.  Higher than typical latency for highly loaded storage indicates saturation (overload) and is frequent cause of performance problems.  Higher than normal latency also can indicate internal storage problems.',
  lines=false,
  datasource='Prometheus',
  points=true,
  pointradius=1,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=true,
  legend_hideEmpty=true,
  legend_hideZero=true,
  editable=true,
  )
  .addTarget(
    prometheus.target(
    '(rate(node_disk_read_time_seconds_total{device=~"$device", node_name="$host"}[$interval]) /
rate(node_disk_reads_completed_total{device=~"$device", node_name="$host"}[$interval])) or
(irate(node_disk_read_time_seconds_total{device=~"$device", node_name="$host"}[5m]) /
irate(node_disk_reads_completed_total{device=~"$device", node_name="$host"}[5m])) or
avg_over_time(aws_rds_read_latency_average{node_name="$host"}[$interval])/1000 or
avg_over_time(aws_rds_read_latency_average{node_name="$host"}[5m])/1000 or
avg_over_time(rdsosmetrics_diskIO_readLatency{node_name="$host"}[$interval])/1000 or
avg_over_time(rdsosmetrics_diskIO_readLatency{node_name="$host"}[5m])/1000',
intervalFactor = 1,
legendFormat='Read: {{device}}',
refId='A',
interval='$interval',
calculatedInterval='2m',
step=300,
    )
  )
  .addTarget(
  prometheus.target(
  '(rate(node_disk_write_time_seconds_total{device=~\"$device\", node_name=\"$host\"}[$interval]) / \nrate(node_disk_writes_completed_total{device=~\"$device\", node_name=\"$host\"}[$interval])) or \n(irate(node_disk_write_time_seconds_total{device=~\"$device\", node_name=\"$host\"}[5m]) / \nirate(node_disk_writes_completed_total{device=~\"$device\", node_name=\"$host\"}[5m])) or \n(avg_over_time(aws_rds_write_latency_average{node_name=\"$host\"}[$interval])/1000 or \navg_over_time(aws_rds_write_latency_average{node_name=\"$host\"}[5m])/1000) or\n(avg_over_time(rdsosmetrics_diskIO_writeLatency{node_name=\"$host\"}[$interval])/1000 or \navg_over_time(rdsosmetrics_diskIO_writeLatency{node_name=\"$host\"}[5m])/1000)',
intervalFactor = 1,
legendFormat='Write: {{device}}',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
  )
  ),gridPos={
  x: 0,
  y: 3,
  w: 24,
  h: 7,
},style=null,
)
.addPanel(
  graphPanel.new(
  'Disk Operations',//title
  fill=2,
  linewidth=2,
  decimals=2,
  description='Shows amount of physical IOs (reads and writes) different devices are serving. Spikes in number of IOs served often corresponds to performance problems due to IO subsystem overload.',
  datasource='Prometheus',
  pointradius=1,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=true,
  legend_hideEmpty=true,
  legend_hideZero=true,
  editable=true,
  )
  .addTarget(
    prometheus.target(
    '(rate(node_disk_reads_completed_total{device=~"$device", node_name="$host"}[$interval]) or
irate(node_disk_reads_completed_total{device=~"$device", node_name="$host"}[5m])) or
(max_over_time(rdsosmetrics_diskIO_readIOsPS{node_name="$host"}[$interval]) or
max_over_time(rdsosmetrics_diskIO_readIOsPS{node_name="$host"}[5m]))',
intervalFactor = 1,
legendFormat='Read: {{device}}',
refId='A',
interval='$interval',
calculatedInterval='2m',
step=300,
    )
  )
  .addTarget(
  prometheus.target(
  '(rate(node_disk_writes_completed_total{device=~"$device", node_name="$host"}[$interval]) or
irate(node_disk_writes_completed_total{device=~"$device", node_name="$host"}[5m])) or
(max_over_time(rdsosmetrics_diskIO_writeIOsPS{node_name="$host"}[$interval]) or
max_over_time(rdsosmetrics_diskIO_writeIOsPS{node_name="$host"}[5m]))',
intervalFactor = 1,
legendFormat='Write: {{device}}',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
  )
  ),gridPos={
  x: 0,
  y: 10,
  w: 24,
  h: 7,
},style=null,
)
.addPanel(
  graphPanel.new(
  'Disk Bandwidth',//title
  fill=2,
  linewidth=2,
  decimals=2,
  description='Shows volume of reads and writes the storage is handling. This can be better measure of IO capacity usage for network attached and SSD storage as it is often bandwidth limited.  Amount of data being written to the disk can be used to estimate Flash storage life time.',
  datasource='Prometheus',
  pointradius=1,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=true,
  legend_hideEmpty=false,
  legend_hideZero=true,
  legend_show=true,
  editable=true,
  )
  .addTarget(
    prometheus.target(
    '(rate(node_disk_read_bytes_total{device=~"$device", node_name="$host"}[$interval]) or
irate(node_disk_read_bytes_total{device=~"$device", node_name="$host"}[5m])) or
(rate(rdsosmetrics_diskIO_readThroughput{node_name="$host"}[$interval]) or
irate(rdsosmetrics_diskIO_readThroughput{node_name="$host"}[5m]))',
intervalFactor = 1,
legendFormat='Read: {{device}}',
refId='A',
interval='$interval',
calculatedInterval='2m',
step=300,
    )
  )
  .addTarget(
  prometheus.target(
  'rate(node_disk_written_bytes_total{device=~"$device", node_name="$host"}[$interval]) or
irate(node_disk_written_bytes_total{device=~"$device", node_name="$host"}[5m]) or
(rate(rdsosmetrics_diskIO_writeThroughput{node_name="$host"}[$interval]) or
irate(rdsosmetrics_diskIO_writeThroughput{node_name="$host"}[5m]))',
intervalFactor = 1,
legendFormat='Write: {{device}}',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
  )
  ),gridPos={
  x: 0,
  y: 17,
  w: 24,
  h: 7,
},style=null,
)
.addPanel(
  graphPanel.new(
  'Disk Load',//title
  fill=2,
  linewidth=2,
  lines=false,
  points=true,
  decimals=2,
  description='Shows how much disk was loaded for reads or writes as average number of outstanding requests at different period of time.  High disk load is a good measure of actual storage utilization. Different storage types handle load differently - some will show latency increases on low loads others can handle higher load with no problems.',
  datasource='Prometheus',
  pointradius=1,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=true,
  legend_hideEmpty=false,
  legend_hideZero=true,
  legend_show=true,
  editable=true,
  )
  .addTarget(
    prometheus.target(
    'rate(node_disk_read_time_seconds_total{device=~"$device", node_name="$host"}[$interval]) or irate(node_disk_read_time_seconds_total{device=~"$device", node_name="$host"}[5m])',
intervalFactor = 1,
legendFormat='Read: {{device}}',
refId='A',
interval='$interval',
calculatedInterval='2m',
step=300,
    )
  )
  .addTarget(
  prometheus.target(
  'rate(node_disk_write_time_seconds_total{device=~"$device", node_name="$host"}[$interval]) or irate(node_disk_write_time_seconds_total{device=~"$device", node_name="$host"}[5m])',
intervalFactor = 1,
legendFormat='Write: {{device}}',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
  )
  ),gridPos={
  x: 0,
  y: 24,
  w: 24,
  h: 7,
},style=null,
)
.addPanel(
  graphPanel.new(
  'Disk IO Utilization',//title
  fill=2,
  linewidth=2,
  decimals=2,
  description='Shows disk Utilization as percent of the time when there was at least one IO request in flight. It is designed to match utilization available in iostat tool. It is not very good measure of true IO Capacity Utilization. Consider looking at IO latency and Disk Load Graphs instead.',
  datasource='Prometheus',
  pointradius=1,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=true,
  legend_hideEmpty=false,
  legend_hideZero=true,
  legend_show=true,
  legend_sort='avg',
  legend_sortDesc=true,
  editable=true,
  )
  .addTarget(
    prometheus.target(
    'rate(node_disk_read_time_seconds_total{device=~"$device", node_name="$host"}[$interval]) or irate(node_disk_read_time_seconds_total{device=~"$device", node_name="$host"}[5m])',
intervalFactor = 1,
legendFormat='Read: {{device}}',
refId='A',
interval='$interval',
calculatedInterval='2m',
step=300,
    )
  )
  .addTarget(
  prometheus.target(
  'rate(node_disk_write_time_seconds_total{device=~"$device", node_name="$host"}[$interval]) or irate(node_disk_write_time_seconds_total{device=~"$device", node_name="$host"}[5m])',
intervalFactor = 1,
legendFormat='Write: {{device}}',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
  )
  ),gridPos={
  x: 0,
  y: 31,
  w: 24,
  h: 7,
},style=null,
)
.addPanel(
  graphPanel.new(
  'Disk Operations Merge Ratio',//title
  fill=2,
  linewidth=2,
  lines=false,
  points=true,
  decimals=2,
  description='Shows how effectively Operating System is able to merge logical IO requests into physical requests.  This is a good measure of the IO locality which can be used for workload characterization.',
  datasource='Prometheus',
  pointradius=1,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=true,
  legend_hideEmpty=true,
  legend_hideZero=true,
  legend_show=true,
  editable=true,
  )
  .addTarget(
    prometheus.target(
    '(1 + rate(node_disk_reads_merged_total{device=~"$device", node_name="$host"}[$interval]) / rate(node_disk_reads_completed_total{device=~"$device", node_name="$host"}[$interval])) or (1 + irate(node_disk_reads_merged_total{device=~"$device", node_name="$host"}[5m]) / irate(node_disk_reads_completed_total{device=~"$device", node_name="$host"}[5m]))',
intervalFactor = 1,
legendFormat='Read Ratio: {{ device }}',
refId='A',
interval='$interval',
calculatedInterval='2m',
step=300,
    )
  )
  .addTarget(
  prometheus.target(
  '(1 + rate(node_disk_writes_merged_total{device=~"$device", node_name="$host"}[$interval]) / rate(node_disk_writes_completed_total{device=~"$device", node_name="$host"}[$interval])) or (1 + irate(node_disk_writes_merged_total{device=~"$device", node_name="$host"}[5m]) / irate(node_disk_writes_completed_total{device=~"$device", node_name="$host"}[5m]))',
intervalFactor = 1,
legendFormat='Write Ratio: {{ device }}',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
  )
  ),gridPos={
  x: 0,
  y: 38,
  w: 24,
  h: 7,
},style=null,
)
.addPanel(
  graphPanel.new(
  'Disk IO Size',//title
  fill=2,
  linewidth=2,
  lines=false,
  points=true,
  decimals=2,
  description='Shows average size of a single disk operation.',
  datasource='Prometheus',
  pointradius=1,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=true,
  legend_hideEmpty=true,
  legend_hideZero=true,
  legend_show=true,
  editable=true,
  aliasColors={
  "Read IO size: sdb": "#2F575E",
  "Read: sdb": "#3F6833",
  }
  )
  .addTarget(
    prometheus.target(
    'rate(node_disk_read_bytes_total{node_name="$host", device=~"$device"}[$interval]) * 512 / rate(node_disk_reads_completed_total{node_name="$host", device=~"$device"}[$interval]) or irate(node_disk_read_bytes_total{node_name="$host", device=~"$device"}[5m]) * 512 / irate(node_disk_reads_completed_total{node_name="$host", device=~"$device"}[5m])',
intervalFactor = 1,
legendFormat='Read size: {{ device }}',
refId='A',
interval='$interval',
calculatedInterval='2m',
step=300,
    )
  )
  .addTarget(
  prometheus.target(
  'rate(node_disk_written_bytes_total{node_name="$host", device=~"$device"}[$interval]) * 512 / rate(node_disk_writes_completed_total{node_name="$host", device=~"$device"}[$interval]) or irate(node_disk_written_bytes_total{node_name="$host", device=~"$device"}[5m]) * 512 / irate(node_disk_writes_completed_total{node_name="$host", device=~"$device"}[5m])',
intervalFactor = 1,
legendFormat='Write size: {{ device }}',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
  )
  ),gridPos={
  x: 0,
  y: 45,
  w: 24,
  h: 7,
},style=null,
)
