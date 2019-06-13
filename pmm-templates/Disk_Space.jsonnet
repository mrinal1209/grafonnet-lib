local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local text = grafana.text;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;

dashboard.new(
  'Disk Space',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=1,
  tags=['OS','Percona'],
  iteration=1553874343697,
  uid="80k9wMHmk",
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
  'label_values(node_filesystem_avail_bytes, node_name)',
  label='Host',
  tagValuesQuery='instance',
  refresh='load',
  sort=1,
  tagsQuery='up',
  refresh_on_load=false,
  allFormat='glob',
  multiFormat='regex values',
  definition='label_values(node_filesystem_avail_bytes, node_name)',
  ),
)
.addTemplate(
  template.new(
  'mountpoint',
  'Prometheus',
  'label_values(node_filesystem_avail_bytes{node_name=~"$host", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}, mountpoint)',
  label='Mountpoint',
  tagValuesQuery='instance',
  refresh='load',
  sort=1,
  tagsQuery='up',
  refresh_on_load=false,
  allFormat='wildcard',
  multiFormat='regex values',
  includeAll=true,
  skipUrlSync=false,

  ),
)
.addPanel(
  graphPanel.new(
  'Mountpoint Usage',//title
  fill=0,
  linewidth=2,
  decimals=2,
  description='Shows the percentage of disk space utilization for every mountpoint defined on the system. Having some of the mountpoints close to 100% space utilization is not good because of the risk to have a “disk full” error that can block one of the services or even cause a crash of the entire system.In case when the mountpoint is close to 100% consider to remove unused files or to expand the space allocated to the mountpoint.',
  datasource='Prometheus',
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=true,
  legend_hideEmpty=false,
  legend_hideZero=false,
  legend_sort="avg",
  legend_sortDesc=true,
  editable=true,
  paceLength=10,
  formatY1 = 'percentunit',
  formatY2 = 'bytes',
  max = 1,
  min = 0,
  aliasColors= {
        "Free (device /dev/xvda1, ext4)": "#82B5D8",
        "Used (device /dev/xvda1, ext4)": "#BA43A9",
      },
   maxPerRow=2,
  )
  .addTarget(
    prometheus.target(
    '1 - node_filesystem_free_bytes{node_name=~"$host", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} / node_filesystem_size_bytes{node_name=~"$host", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
intervalFactor = 1,
legendFormat='{{ mountpoint }}',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
hide=false,
    )
  ),gridPos={
  x: 0,
  y: 0,
  w: 24,
  h: 7,
},style=null,
)
.addPanel(
  text.new(
  content='`Disk Space` -  Amount of disk space used and available on various mount points.  Running out of disk space on OS volume,  database volume or volume used for temporary space can cause downtime.   Some storage may also have reduced performance when small amount of space is available.',
  datasource='Prometheus',
  editable=true,
  height='50px',
  id=8,
  transparent=true,
  ),gridPos={
  x: 0,
  y: 7,
  w: 24,
  h: 3,
},style={},
)
.addPanel(
  graphPanel.new(
  'Mountpoint $mountpoint',//title
  fill=6,
  linewidth=2,
  decimals=2,
  description='Shows information about the disk space usage of the specified mountpoint.**Used** is the amount of space used.**Free** is the amount of space not in use.**Used+Free** is the total disk space allocated to the mountpoint.Having *Free* close to 0 B is not good because of the risk to have a “disk full” error that can block one of the services or even cause a crash of the entire system.In case Free is close to 0 B consider to remove unused files or to expand the space allocated to the mountpoint.',
  datasource='Prometheus',
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=false,
  legend_hideEmpty=false,
  legend_show=true,
  editable=true,
  aliasColors={
        "Free (device /dev/xvda1, ext4)": "#82B5D8",
        "Used (device /dev/xvda1, ext4)": "#BA43A9"
  },
  repeat='mountpoint',
  paceLength=10,
  stack=true,
  format='bytes',
  maxPerRow=2,
  )
  .addSeriesOverride(
    {
       "alias": "/Used/",
       "color": "#99440A",
     }
  )
  .addSeriesOverride(
     {
       "alias": "/Free/",
       "color": "#EF843C",
     }
  )
  .addTarget(
    prometheus.target(
    'node_filesystem_size_bytes{node_name=~"$host",mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} - node_filesystem_free_bytes{node_name=~"$host",mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
intervalFactor = 1,
legendFormat='Used (device {{ device }}, {{ fstype }})',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
hide=false,
    )
  )
  .addTarget(
  prometheus.target(
  'node_filesystem_free_bytes{node_name=~"$host", mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
intervalFactor = 1,
legendFormat='Free (device {{ device }}, {{ fstype }})',
refId='A',
interval='$interval',
calculatedInterval='2m',
step=300,
  )
  ),gridPos={
  x: 0,
  y: 10,
  w: 12,
  h: 7,
},style=null,
)
.addPanel(
  graphPanel.new(
  'Mountpoint $mountpoint',//title
  fill=6,
  linewidth=2,
  decimals=2,
  description='Shows information about the disk space usage of the specified mountpoint.**Used** is the amount of space used.**Free** is the amount of space not in use.**Used+Free** is the total disk space allocated to the mountpoint.Having *Free* close to 0 B is not good because of the risk to have a “disk full” error that can block one of the services or even cause a crash of the entire system.In case Free is close to 0 B consider to remove unused files or to expand the space allocated to the mountpoint.',
  datasource='Prometheus',
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=false,
  legend_hideEmpty=false,
  legend_show=true,
  editable=true,
  aliasColors={
        "Free (device /dev/xvda1, ext4)": "#82B5D8",
        "Used (device /dev/xvda1, ext4)": "#BA43A9"
  },
  paceLength=10,
  stack=true,
  format='bytes',
  maxPerRow=2,
  repeatIteration=1553874343697,
  repeatPanelId = 4,
  )
  .addSeriesOverride(
    {
       "alias": "/Used/",
       "color": "#99440A",
     }
  )
  .addSeriesOverride(
     {
       "alias": "/Free/",
       "color": "#EF843C",
     }
  )
  .addTarget(
    prometheus.target(
    'node_filesystem_size_bytes{node_name=~"$host",mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} - node_filesystem_free_bytes{node_name=~"$host",mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
intervalFactor = 1,
legendFormat='Used (device {{ device }}, {{ fstype }})',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
hide=false,
    )
  )
  .addTarget(
  prometheus.target(
  'node_filesystem_free_bytes{node_name=~"$host", mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
intervalFactor = 1,
legendFormat='Free (device {{ device }}, {{ fstype }})',
refId='A',
interval='$interval',
calculatedInterval='2m',
step=300,
  )
  ),gridPos={
  x: 12,
  y: 10,
  w: 12,
  h: 7,
},style=null,
)
.addPanel(
  graphPanel.new(
  'Mountpoint $mountpoint',//title
  fill=6,
  linewidth=2,
  decimals=2,
  description='Shows information about the disk space usage of the specified mountpoint.

**Used** is the amount of space used.

**Free** is the amount of space not in use.

**Used+Free** is the total disk space allocated to the mountpoint.

Having *Free* close to 0 B is not good because of the risk to have a “disk full” error that can block one of the services or even cause a crash of the entire system.

In case Free is close to 0 B consider to remove unused files or to expand the space allocated to the mountpoint.',
  datasource='Prometheus',
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=false,
  legend_hideEmpty=false,
  legend_show=true,
  editable=true,
  aliasColors={
        "Free (device /dev/xvda1, ext4)": "#82B5D8",
        "Used (device /dev/xvda1, ext4)": "#BA43A9"
  },
  paceLength=10,
  stack=true,
  format='bytes',
  maxPerRow=2,
  repeatIteration=1553874343697,
  repeatPanelId = 4,
  )
  .addSeriesOverride(
    {
       "alias": "/Used/",
       "color": "#99440A",
     }
  )
  .addSeriesOverride(
     {
       "alias": "/Free/",
       "color": "#EF843C",
     }
  )
  .addTarget(
    prometheus.target(
    'node_filesystem_size_bytes{node_name=~"$host",mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} - node_filesystem_free_bytes{node_name=~"$host",mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
intervalFactor = 1,
legendFormat='Used (device {{ device }}, {{ fstype }})',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
hide=false,
    )
  )
  .addTarget(
  prometheus.target(
  'node_filesystem_free_bytes{node_name=~"$host", mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
intervalFactor = 1,
legendFormat='Free (device {{ device }}, {{ fstype }})',
refId='A',
interval='$interval',
calculatedInterval='2m',
step=300,
  )
  ),gridPos={
  x: 0,
  y: 17,
  w: 12,
  h: 7,
},style=null,
)
.addPanel(
  graphPanel.new(
  'Mountpoint $mountpoint',//title
  fill=6,
  linewidth=2,
  decimals=2,
  description='Shows information about the disk space usage of the specified mountpoint.

**Used** is the amount of space used.

**Free** is the amount of space not in use.

**Used+Free** is the total disk space allocated to the mountpoint.

Having *Free* close to 0 B is not good because of the risk to have a “disk full” error that can block one of the services or even cause a crash of the entire system.

In case Free is close to 0 B consider to remove unused files or to expand the space allocated to the mountpoint.',
  datasource='Prometheus',
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=false,
  legend_hideEmpty=false,
  legend_show=true,
  editable=true,
  aliasColors={
        "Free (device /dev/xvda1, ext4)": "#82B5D8",
        "Used (device /dev/xvda1, ext4)": "#BA43A9"
  },
  paceLength=10,
  stack=true,
  format='bytes',
  maxPerRow=2,
  repeatIteration=1553874343697,
  repeatPanelId = 4,
  )
  .addSeriesOverride(
    {
       "alias": "/Used/",
       "color": "#99440A",
     }
  )
  .addSeriesOverride(
     {
       "alias": "/Free/",
       "color": "#EF843C",
     }
  )
  .addTarget(
    prometheus.target(
    'node_filesystem_size_bytes{node_name=~"$host",mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} - node_filesystem_free_bytes{node_name=~"$host",mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
intervalFactor = 1,
legendFormat='Used (device {{ device }}, {{ fstype }})',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
hide=false,
    )
  )
  .addTarget(
  prometheus.target(
  'node_filesystem_free_bytes{node_name=~"$host", mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
intervalFactor = 1,
legendFormat='Free (device {{ device }}, {{ fstype }})',
refId='A',
interval='$interval',
calculatedInterval='2m',
step=300,
  )
  ),gridPos={
  x: 12,
  y: 17,
  w: 12,
  h: 7,
},style=null,
)
.addPanel(
  graphPanel.new(
  'Mountpoint $mountpoint',//title
  fill=6,
  linewidth=2,
  decimals=2,
  description='Shows information about the disk space usage of the specified mountpoint.

**Used** is the amount of space used.

**Free** is the amount of space not in use.

**Used+Free** is the total disk space allocated to the mountpoint.

Having *Free* close to 0 B is not good because of the risk to have a “disk full” error that can block one of the services or even cause a crash of the entire system.

In case Free is close to 0 B consider to remove unused files or to expand the space allocated to the mountpoint.',
  datasource='Prometheus',
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=false,
  legend_hideEmpty=false,
  legend_show=true,
  editable=true,
  aliasColors={
        "Free (device /dev/xvda1, ext4)": "#82B5D8",
        "Used (device /dev/xvda1, ext4)": "#BA43A9"
  },
  paceLength=10,
  stack=true,
  format='bytes',
  maxPerRow=2,
  repeatIteration=1553874343697,
  repeatPanelId = 4,
  )
  .addSeriesOverride(
    {
       "alias": "/Used/",
       "color": "#99440A",
     }
  )
  .addSeriesOverride(
     {
       "alias": "/Free/",
       "color": "#EF843C",
     }
  )
  .addTarget(
    prometheus.target(
    'node_filesystem_size_bytes{node_name=~"$host",mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} - node_filesystem_free_bytes{node_name=~"$host",mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
intervalFactor = 1,
legendFormat='Used (device {{ device }}, {{ fstype }})',
refId='B',
interval='$interval',
calculatedInterval='2m',
step=300,
hide=false,
    )
  )
  .addTarget(
  prometheus.target(
  'node_filesystem_free_bytes{node_name=~"$host", mountpoint="$mountpoint", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
intervalFactor = 1,
legendFormat='Free (device {{ device }}, {{ fstype }})',
refId='A',
interval='$interval',
calculatedInterval='2m',
step=300,
  )
  ),gridPos={
  x: 0,
  y: 24,
  w: 12,
  h: 7,
},style=null,
)
