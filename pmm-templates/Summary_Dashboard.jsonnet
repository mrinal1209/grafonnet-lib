local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local row = grafana.row;


dashboard.new(
  'Summary Dashboard',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=1,
  tags=['Percona','Insight'],
  iteration=1555312399374,
  uid="qBWRrTiik",
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
  'label_values({__name__=~"node_load1|process_start_time_seconds"},node_name)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='regex values',
  multi=false,
  skipUrlSync=false,
  definition='label_values({__name__=~"node_load1|process_start_time_seconds"},node_name)',
  tagsQuery='up',
  tagValuesQuery='instance',
  refresh_on_load=false,
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values({__name__=~"postgres_exporter_build_info|mysqld_exporter_build_info|mongodb_exporter_build_info|proxysql_exporter_build_info",node_name=~"$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=0,
  multi=true,
  skipUrlSync=false,
  includeAll=true,
  definition='label_values({__name__=~"postgres_exporter_build_info|mysqld_exporter_build_info|mongodb_exporter_build_info|proxysql_exporter_build_info",node_name=~"$host"}, service_name)',
  ),
)
.addPanel(
    row.new(
      title='System Stats',
    ),
    gridPos={
       "h": 1,
        "w": 24,
        "x": 0,
        "y": 0,
    },
    style=null,
)//37 row
.addPanel(
  graphPanel.new(
    'CPU Usage',//title
    description='**CPU Usage**

    The CPU Usage graph shows how much of the overall CPU time is used by the server.  It has 4 components: system, user, iowait and softirq.  System is the proportion of time the CPU spent inside the Linux kernel for operations like context switching, memory allocation and queue handling.  User is the time spent in the user space.  Normally, most of the MySQL CPU time is in user space, a too high value may indicate an indexing issue.  Iowait is the time the CPU spent waiting for disk IO requests to complete.  A high value of iowait indicates a disk bound load.  Softirq is the portion of time the CPU spent servicing software interrupts generated by the device drivers.  A high value of softirq may indicates a poorly configured device.  The network is generally the main source of high softirq values.   Be aware the graph presents global values, while there may be a lot of unused CPU, a single core may be saturated.  Look for any quantity saturating at 100/(cpu core count).',
    fill=5,
    linewidth=1,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    legend_rightSide=true,
    legend_hideEmpty=true,
    legend_hideZero=true,
    editable=true,
    formatY1='percent',
    min=0,
    maxY1='100',
    decimalsY1=1,
    aliasColors={
        "Max Core Utilization": "#bf1b00",
        "idle": "#705DA0",
        "iowait": "#E24D42",
        "nice": "#1F78C1",
        "softirq": "#806EB7",
        "system": "#EAB839",
        "user": "#508642"
      },
    links=[
          {
            "title": "Understanding Linux CPU stats",
            "type": "absolute",
            "url": "http://blog.scoutapp.com/articles/2015/02/24/understanding-linuxs-cpu-stats"
          }
        ],
    stack=true,
   )
  .addSeriesOverride(
      {
        "alias": "Max Core Utilization",
        "lines": false,
        "pointradius": 1,
        "points": true,
        "stack": false
      }
    )
  .addTarget(
      prometheus.target(
        'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name="$host",mode!="idle"}[$interval]),1)) or
        (clamp_max(irate(node_cpu_seconds_total{node_name="$host",mode!="idle"}[5m]),1)) ))*100 or
        (avg_over_time(node_cpu_average{node_name=~"$host", mode!="total", mode!="idle"}[$interval]) or
        avg_over_time(node_cpu_average{node_name=~"$host", mode!="total", mode!="idle"}[5m]))),100)',
        refId='B',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{mode}}'
      )
   )
  .addTarget(
      prometheus.target(
        'clamp_max(max by () (sum  by (cpu) ( (clamp_max(rate(node_cpu_seconds_total{node_name="$host",mode!="idle",mode!="iowait"}[$interval]),1)) or
        (clamp_max(irate(node_cpu_seconds_total{node_name="$host",mode!="idle",mode!="iowait"}[5m]),1)) )),1)',
        refId='C',
        interval='$interval',
        legendFormat='Max Core Utilization',
        intervalFactor=1,
        hide=true,
      )
      ),
  gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 1,
   },
  style=null,
)//2 graph
.addPanel(
    row.new(
      title='Processes',
    ),
    gridPos={
       "h": 1,
        "w": 24,
        "x": 0,
        "y": 8,
    },
    style=null,
)//38 row
.addPanel(
  graphPanel.new(
    'Processes',//title
    description='**Processes**

    The Processes graph shows how many processes/threads are either in the kernel run queue (runnable state) or in the blocked queue (waiting for I/O).  When the number of process in the runnable state is constantly higher than the number of CPU cores available, the load is CPU bound.  When the number of process blocked waiting for I/O is large, the load is disk bound.  The running average of the sum of these two quantities is the basis of the loadavg metric.',
    fill=2,
    linewidth=2,
    bars=true,
    lines=false,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    legend_hideEmpty=false,
    editable=true,
    format='none',
    min=0,
    links=[
        {
          "includeVars": false,
          "keepTime": false,
          "title": "Vmstat Output explained",
          "type": "absolute",
          "url": "http://nonfunctionaltestingtools.blogspot.ca/2013/03/vmstat-output-explained.html"
        }
        ],
    stack=true,
   )
  .addSeriesOverride(
      {
        "alias": "Processes blocked waiting for I/O to complete",
        "color": "#E24D42"
      }
    )
  .addSeriesOverride(
      {
        "alias": "Processes in runnable state",
        "color": "#6ED0E0"
      }
      )
  .addTarget(
      prometheus.target(
        'node_procs_running{node_name="$host"}',
        refId='A',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Processes in runnable state',
        calculatedInterval='2m',
        step=300,
      )
   )
  .addTarget(
      prometheus.target(
        'node_procs_blocked{node_name="$host"}',
        refId='B',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Processes blocked waiting for I/O to complete',
        calculatedInterval='2m',
        step=300,
      )
      ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 9
   },
  style=null,
)//20 graph
.addPanel(
  graphPanel.new(
    'Network Traffic',//title
    description='**Network Traffic**

    The Network Traffic graph shows the rate of data transferred over the network.  Outbound is the data sent by the server while Inbound is the data received by the server.  Look for signs of saturation given the capacity of the network devices.  If the outbound rate is constantly high and close to saturation and you have plenty of available CPU, you should consider activating the compression option on the MySQL clients and slaves.',
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
    legend_sortDesc=true,
    legend_sort='avg',
    legend_hideEmpty=false,
    editable=true,
    formatY1='Bps',
    formatY2='bytes',
    min=0,
    stack=true,
   )
  .addTarget(
      prometheus.target(
        'sum(rate(node_network_receive_bytes_total{node_name="$host", device!="lo"}[$interval])) or
        sum(irate(node_network_receive_bytes_total{node_name="$host", device!="lo"}[5m])) or
        sum(max_over_time(rdsosmetrics_network_rx{node_name="$host"}[$interval])) or
        sum(max_over_time(rdsosmetrics_network_rx{node_name="$host"}[5m])) ',
        refId='A',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Inbound',
        calculatedInterval='2s',
        step=300,
      )
   )
  .addTarget(
      prometheus.target(
        'sum(rate(node_network_transmit_bytes_total{node_name="$host", device!="lo"}[$interval])) or
        sum(irate(node_network_transmit_bytes_total{node_name="$host", device!="lo"}[5m])) or
        sum(max_over_time(rdsosmetrics_network_tx{node_name="$host"}[$interval])) or
        sum(max_over_time(rdsosmetrics_network_tx{node_name="$host"}[5m]))',
        refId='B',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Outbound',
        calculatedInterval='2s',
        step=300,
      )
      ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 9
   },
  style=null,
)//21 graph
.addPanel(
    row.new(
      title='I/O',
    ),
    gridPos={
       "h": 1,
        "w": 24,
        "x": 0,
        "y": 16,
    },
    style=null,
)//39 row
.addPanel(
  graphPanel.new(
    'I/O Activity',//title
    description='**I/O Activity**

    The I/O Activity graph shows the rates of data read from (Page In) and written to (Page Out) the all the disks as collected from the vmstat bi and bo columns.',
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
    legend_sortDesc=true,
    legend_sort='avg',
    legend_hideEmpty=false,
    editable=true,
    formatY1='Bps',
    formatY2='bytes',
    min=0,
   )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pgpgin{node_name="$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgin{node_name="$host"}[5m]) * 1024',
        refId='A',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Page In',
        calculatedInterval='2s',
        step=300,
      )
   )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pgpgout{node_name="$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgout{node_name="$host"}[5m]) * 1024',
        refId='B',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Page Out',
        calculatedInterval='2s',
        step=300,
      )
      ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 17
   },
  style=null,
)//31 graph
.addPanel(
  graphPanel.new(
    'Disk Latency',//title
    description='**Disk Latency**

    The Disk Latency graph shows the average time to complete read an write operations to the disks.  There is one data series per operation type (Read or Write) per disk mounted to the server.  High latency values, typically more than 15 ms,  are an indication of a disk bound workload saturating the storage subsystem or, a faulty/degraded hardware.',
    fill=2,
    linewidth=2,
    lines=false,
    points=true,
    datasource='Prometheus',
    pointradius=1,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_hideEmpty=true,
    legend_hideZero=true,
    editable=true,
    format='s',
    minY2=0,
    logBase1Y=2,
   )
  .addTarget(
      prometheus.target(
        '(rate(node_disk_read_time_seconds_total{device!~"dm-.+", node_name="$host"}[$interval]) /
        rate(node_disk_reads_completed_total{device!~"dm-.+", node_name="$host"}[$interval])) or
        (irate(node_disk_read_time_seconds_total{device!~"dm-.+", node_name="$host"}[5m]) /
        irate(node_disk_reads_completed_total{device!~"dm-.+", node_name="$host"}[5m])) or
        avg_over_time(aws_rds_read_latency_average{node_name="$host"}[$interval])/1000 or
        avg_over_time(aws_rds_read_latency_average{node_name="$host"}[5m])/1000',
        refId='A',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Read: {{ device }}',
        calculatedInterval='2m',
        step=300,
      )
   )
  .addTarget(
      prometheus.target(
        '(rate(node_disk_write_time_seconds_total{device!~"dm-.+", node_name="$host"}[$interval]) /
        rate(node_disk_writes_completed_total{device!~"dm-.+", node_name="$host"}[$interval])) or
        (irate(node_disk_write_time_seconds_total{device!~"dm-.+", node_name="$host"}[5m]) /
        irate(node_disk_writes_completed_total{device!~"dm-.+", node_name="$host"}[5m])) or
        (avg_over_time(aws_rds_write_latency_average{node_name="$host"}[$interval])/1000 or
        avg_over_time(aws_rds_write_latency_average{node_name="$host"}[5m])/1000)',
        refId='B',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Write: {{ device }}',
        calculatedInterval='2m',
        step=300,
      )
      ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 17
   },
  style=null,
)//36 graph
.addPanel(
    row.new(
      title='MySQL Stats',
    ),
    gridPos={
     "h": 1,
      "w": 24,
      "x": 0,
      "y": 24,
    },
    style=null,
)//40 row
.addPanel(
  graphPanel.new(
    'MySQL Queries',//title
    description='**MySQL Queries**

    The MySQL Queries graph shows the rate of queries processed by MySQL.  The rate of queries is a rough indication of the MySQL server load.',
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
    min=0,
   )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_queries{node_name="$host"}[$interval]) or irate(mysql_global_status_queries{node_name="$host"}[5m])',
        refId='A',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Queries - {{service_name}}',
        calculatedInterval='2m',
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
)//35 graph
.addPanel(
  graphPanel.new(
    'InnoDB Row Operations',//title
    description='**InnoDB Row Operations**

    The InnoDB Row Operations graph shows the rate of rows processed by InnoDB.  It is a good indication of the MySQL server load.  A high value of Rows read, which can easily be above a million, is an indication of poor queries or deficient indexing.  The amounts of rows inserted, updated and deleted help appreciate the server write load.',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    height='270px',
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_sortDesc=true,
    legend_sort='avg',
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    min=0,
   )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_innodb_row_ops_total{node_name="$host"}[$interval]) or
        irate(mysql_global_status_innodb_row_ops_total{node_name="$host"}[5m])',
        refId='A',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Rows {{ operation }} - {{service_name}}',
        calculatedInterval='2m',
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
)//34 graph
.addPanel(
    row.new(
      title='Top MySQL Commands',
    ),
    gridPos={
     "h": 1,
      "w": 24,
      "x": 0,
      "y": 32,
    },
    style=null,
)//41 row
.addPanel(
  graphPanel.new(
    'Top MySQL Commands',//title
    description='**Top MySQL Commands**

    The Top MySQL Commands graph shows the rate of the various kind of SQL statements executed on the MySQL server.',
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
    legend_rightSide=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    min=0,
   )
  .addTarget(
      prometheus.target(
        'topk(5, rate(mysql_global_status_commands_total{node_name="$host"}[$interval])>0) or
        topk(5, irate(mysql_global_status_commands_total{node_name="$host"}[5m])>0)',
        refId='A',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Com_{{ command }} - {{service_name}}',
        calculatedInterval='2m',
        step=300,
      )
      ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 33,
   },
  style=null,
)//32 graph
.addPanel(
    row.new(
      title='Top MySQL Handlers',
    ),
    gridPos={
     "h": 1,
      "w": 24,
      "x": 0,
      "y": 40,
    },
    style=null,
)//42 row
.addPanel(
  graphPanel.new(
    'Top MySQL Handlers',//title
    description='**Top MySQL Handlers**

    The Top MySQL Handlers graph shows the rate of the various low level storage engine handler calls. The most important ones to watch are read_next and read_rnd_next.  A high values for read_rnd_next is an indication there are table scans while a high value of read_next is an indication of index scans.',
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
    legend_rightSide=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_hideZero=true,
    editable=true,
    min=0,
   )
  .addTarget(
      prometheus.target(
        'topk(5, rate(mysql_global_status_handlers_total{node_name="$host"}[$interval])>0) or
        topk(5, irate(mysql_global_status_handlers_total{node_name="$host"}[5m])>0)',
        refId='J',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{ handler }} - {{service_name}}',
        calculatedInterval='2m',
        step=300,
      )
      ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 41,
   },
  style=null,
)//33 graph
