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
local tablePanel = grafana.tablePanel;



dashboard.new(
  'Prometheus',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=3,
  tags=['Insight','Percona'],
  iteration=1563534328600,
  uid="SK8vJ2Hiz",
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
    tags = [  "pmm_annotation",
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
  template.pmmCustom(
  'pmmhost',
  'custom',
  'pmm-server',
  hide=2,
  options=[
          {
            "selected": true,
            "text": "pmm-server",
            "value": "pmm-server"
          }
        ],
  )
)
.addPanel(
  text.new(
    content="<h1><i><font color=#5991A7><b><center>Data for </font><font color=#e68a00>PMM Server</font> <font color=#5991A7> with</font> </font><font color=#e68a00>$interval</font> <font color=#5991A7>resolution</center></b></font></i></h1>",
    mode='html',
  ),
  gridPos={
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 0,
      },
  style=null,
)//97 text
.addPanel(
    row.new(
      title='Prometheus Overview',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 2,
    },
    style=null,
)//74 row
.addPanel(
  pmmSinglestat.new(
    'CPU Usage',//title
    description='CPU Usage by Prometheus Process Only',
    format='percent',
    decimals=null,
    datasource='Prometheus',
    valueName='current',
    thresholds='60,80',
    colorValue=true,
    colors=[
      "#299c46",
     "rgba(237, 129, 40, 0.89)",
     "#d44a3a",
    ],
    sparklineShow=true,
    sparklineMaxValue=110,
    interval=null,
    height=null,
    valueFontSize='150%',
  )
  .addTarget(
    prometheus.target(
      '(sum(rate(process_cpu_seconds_total{job="prometheus"}[$interval])) by () or sum(irate(process_cpu_seconds_total{job="prometheus"}[5m])) by ()) / count(node_cpu_seconds_total{mode="user", node_name="PMM Server"})*100',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
    "h": 2,
    "w": 3,
    "x": 0,
    "y": 3
  },
  style=null,
)//93 pmm-singlestat
.addPanel(
  pmmSinglestat.new(
    'Memory Usage',//title
    description='Memory Allocated and In use by Prometheus Process Only',
    format='percent',
    decimals=null,
    datasource='Prometheus',
    valueName='current',
    thresholds='30,60',
    colorValue=true,
    colors=[
      "#299c46",
     "rgba(237, 129, 40, 0.89)",
     "#d44a3a",
    ],
    sparklineShow=true,
    interval=null,
    height=null,
    valueFontSize='150%',
  )
  .addTarget(
    prometheus.target(
      '100*sum(go_memstats_alloc_bytes{job="prometheus"}+go_memstats_stack_inuse_bytes{job="prometheus"}) by () /
      sum(node_memory_MemTotal_bytes{node_name="PMM Server"}) by ()',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos={
    "h": 2,
    "w": 3,
    "x": 3,
    "y": 3
  },
  style=null,
)//95 pmm-singlestat
.addPanel(
  singlestat.new(
    'Scrapes Performed',//title
    format='ops',
    editable=true,
    decimals=null,
    datasource='Prometheus',
    valueName='current',
    thresholds='0.7,0.8',
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)",
    ],
    sparklineShow=true,
    interval='$interval',
    height='125px',
    valueFontSize='50%',
  )
  .addTarget(
    prometheus.target(
      'sum(rate(prometheus_target_interval_length_seconds_count[$interval])) or sum(irate(prometheus_target_interval_length_seconds_count[5m]))',
      intervalFactor = 1,
      interval='$interval',
      step=300,
    )
  ),
  gridPos = {
        "h": 2,
        "w": 3,
        "x": 6,
        "y": 3
  },
  style=null,
)//37 singlestat
.addPanel(
  singlestat.new(
    'Samples Ingested',//title
    description="Samples Ingested per second through scraping activity",
    format='ops',
    editable=true,
    decimals=1,
    datasource='Prometheus',
    valueName='current',
    thresholds='0.7,0.8',
    colors=[
      "#299c46",
       "rgba(237, 129, 40, 0.89)",
       "#d44a3a"
    ],
    interval=null,
    sparklineShow=true,
    height='125px',
    valueFontSize='50%',
  )
  .addTarget(
    prometheus.target(
      'rate(prometheus_tsdb_head_samples_appended_total[$interval]) or irate(prometheus_tsdb_head_samples_appended_total[5m])',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
        "h": 2,
        "w": 3,
        "x": 9,
        "y": 3
  },
  style=null,
)//60 singlestat
.addPanel(
  singlestat.new(
    'Active Data blocks',//title
    description="Number of currently loaded data blocks",
    format='none',
    editable=true,
    decimals=null,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    sparklineShow=true,
    colors=[
      "#299c46",
       "rgba(237, 129, 40, 0.89)",
       "#d44a3a"
    ],
    interval=null,
    height='125px',
    valueFontSize='50%',
  )
  .addTarget(
    prometheus.target(
      'prometheus_tsdb_blocks_loaded',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
        "h": 2,
        "w": 3,
        "x": 12,
        "y": 3
  },
  style=null,
)//98 singlestat
.addPanel(
  singlestat.new(
    'Active Series',//title
    format='short',
    editable=true,
    decimals=2,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colors=[
      "#299c46",
       "rgba(237, 129, 40, 0.89)",
       "#d44a3a"
    ],
    sparklineShow=true,
    interval=null,
    height='125px',
    valueFontSize='50%',
  )
  .addTarget(
    prometheus.target(
      'prometheus_tsdb_head_series',
      intervalFactor = 2,
      legendFormat='series',
    )
  ),
  gridPos = {
        "h": 2,
        "w": 3,
        "x": 15,
        "y": 3
  },
  style=null,
)//100 singlestat
.addPanel(
  singlestat.new(
    'Head Block Retention',//title
    format='ms',
    editable=true,
    decimals=2,
    datasource='Prometheus',
    valueName='current',
    thresholds='300,3600',
    colors=[
      "#d44a3a",
      "rgba(237, 129, 40, 0.89)",
      "#299c46"
    ],
    interval=null,
    height='125px',
    postfix='s',
    valueFontSize='50%',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'prometheus_tsdb_head_max_time - prometheus_tsdb_head_min_time',
      intervalFactor = 1,
      interval='',
    )
  ),
  gridPos = {
        "h": 2,
        "w": 3,
        "x": 18,
        "y": 3
  },
  style=null,
)//101 singlestat
.addPanel(
  pmmSinglestat.new(
    'Capacity Usage',//title
    description="Estimated usage of Memory Resources based on current Ingest rate",
    format='percent',
    decimals=null,
    datasource='Prometheus',
    valueName='current',
    thresholds='60,80',
    colorValue=true,
    sparklineShow=true,
    colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a"
    ],
    interval=null,
    valueFontSize='150%',
  )
  .addTarget(
    prometheus.target(
      '(sum(rate(prometheus_tsdb_head_samples_appended_total[15m])) by () *10800*3) / ((sum(node_memory_MemTotal_bytes{node_name="PMM Server"}) by ()-419430400)*0.35)*100',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
        "h": 2,
        "w": 3,
        "x": 21,
        "y": 3
  },
  style=null,
)//102 pmm-singlestat
.addPanel(
    row.new(
      title='Resources',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'Prometheus Process CPU Usage',//title
        fill=0,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        editable=true,
        height='250',
        value_type='cumulative',
        formatY1='none',
        min=0,
        aliasColors={
            "CPU Cores Total": "#BF1B00",
            "Recommended Limit": "#cca300"
          },
      )
      .addSeriesOverride({
              "alias": "CPU",
              "color": "#E24D42"
            })
      .addSeriesOverride({
              "alias": "CPU Cores Used",
              "fill": 1
            })
      .addTarget(
          prometheus.target(
            'rate(process_cpu_seconds_total{job="prometheus"}[$interval]) or irate(process_cpu_seconds_total{job="prometheus"}[5m])',
            interval='$interval',
            step=60,
            intervalFactor=1,
            legendFormat='CPU Cores Used',
          )
      )
      .addTarget(
          prometheus.target(
            'count(node_cpu_seconds_total{mode="user", node_name="PMM Server"})',
            interval='$interval',
            step=40,
            intervalFactor=1,
            legendFormat='CPU Cores Total',
          )
      )
      .addTarget(
          prometheus.target(
            'count(node_cpu_seconds_total{mode="user", node_name="PMM Server"})*0.75',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Recommended Limit',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 6
      }
    )//3 graph
    .addPanel(
      graphPanel.new(
        'Prometheus Process  Memory Usage',//title
        fill=0,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        editable=true,
        height='250',
        value_type='cumulative',
        formatY1='bytes',
        min=0,
        aliasColors={
            "Resident Memory": "#629E51",
            "Total System Memory": "#890F02",
            "Virtual Memory": "#705da0"
          },
      )
      .addSeriesOverride({
              "alias": "Memory",
              "color": "#EF843C"
            })
      .addSeriesOverride({
              "alias": "Resident Memory",
              "fill": 1
            })
      .addTarget(
          prometheus.target(
            'process_resident_memory_bytes{job="prometheus"}',
            interval='$interval',
            step=60,
            intervalFactor=1,
            legendFormat='Resident Memory',
          )
      )
      .addTarget(
          prometheus.target(
            'process_virtual_memory_bytes{job="prometheus"}',
            interval='$interval',
            step=60,
            intervalFactor=1,
            legendFormat='Virtual Memory',
          )
      )
      .addTarget(
          prometheus.target(
            'go_memstats_alloc_bytes{job="prometheus"}+go_memstats_stack_inuse_bytes{job="prometheus"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Go Memory Allocated and In Use',
            step=60,
          )
      )
      .addTarget(
          prometheus.target(
            'node_memory_MemTotal_bytes{node_name="PMM Server"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total System Memory',
            step=60,
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 6
      }
    )//5 graph
    .addPanel(
      graphPanel.new(
        'Disk Space Utilization',//title
        fill=8,
        linewidth=2,
        decimals=2,
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
        formatY1='bytes',
        minY1='0',
        aliasColors={
            "Free Disk Space": "#629e51",
            "Used Disk Space": "#eab839"
          },
      )
      .addSeriesOverride({
              "alias": "Total Disk Space",
              "color": "#bf1b00",
              "fill": 0,
              "stack": false
            })
      .addTarget(
          prometheus.target(
            '(node_filesystem_size_bytes{node_name="PMM Server",mountpoint="/srv",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} or
            node_filesystem_size_bytes{node_name="PMM Server",mountpoint="/",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} ) -
            (node_filesystem_free_bytes{node_name="PMM Server",mountpoint="/srv",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} or
            node_filesystem_free_bytes{node_name="PMM Server",mountpoint="/",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"})',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Used Disk Space',
          )
      )
      .addTarget(
          prometheus.target(
            'node_filesystem_free_bytes{node_name="PMM Server", mountpoint="/srv",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} or
            node_filesystem_free_bytes{node_name="PMM Server", mountpoint="/",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Free Disk Space',
          )
      )
      .addTarget(
          prometheus.target(
            'node_filesystem_size_bytes{node_name="PMM Server",mountpoint="/srv",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} or
            node_filesystem_size_bytes{node_name="PMM Server",mountpoint="/",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total Disk Space',
          )
      ),
      gridPos={
        "h": 7,
          "w": 12,
          "x": 0,
          "y": 13
      }
    )//86 graph
    .addPanel(
      graphPanel.new(
        'Time before run out of space',//title
        fill=0,
        linewidth=3,
        decimals=2,
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
        formatY1='h',
        logBase1Y=2,
        minY1='0',
        aliasColors={
            "Time Left on /": "#1f78c1"
          },
      )
      .addTarget(
          prometheus.target(
            'node_filesystem_free_bytes{node_name="PMM Server",mountpoint="/srv",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}/
            clamp_min((node_filesystem_free_bytes{node_name="PMM Server",mountpoint="/srv",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} -
            predict_linear(node_filesystem_free_bytes{node_name="PMM Server", mountpoint="/srv",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}[1h], 1 * 3600)),0)
            or
            node_filesystem_free_bytes{node_name="PMM Server",mountpoint="/",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}/
            clamp_min((node_filesystem_free_bytes{node_name="PMM Server",mountpoint="/",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} -
            predict_linear(node_filesystem_free_bytes{node_name="PMM Server", mountpoint="/",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}[1h], 1 * 3600)),0)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Time Left on {{mountpoint}}',
          )
      ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 12,
          "y": 13
      }
    )//86 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 5,
    },
    style=null,
)//75 row
.addPanel(
    row.new(
      title='Storage (TSDB) Overview',
      collapse=true,
    )
    .addPanel(
      singlestat.new(
        'Avg Chunk Time',//title
        format='ms',
        decimals=2,
        datasource='Prometheus',
        valueName='current',
        thresholds='300,3600',
        colorValue=false,
        sparklineShow=true,
        colors=[
          "#d44a3a",
           "rgba(237, 129, 40, 0.89)",
           "#299c46"
        ],
        height='125px',
        interval=null,
        valueFontSize='50%',
        postfix='s',
      )
      .addTarget(
        prometheus.target(
          'rate(prometheus_tsdb_compaction_chunk_range_seconds_sum[6h])/rate(prometheus_tsdb_compaction_chunk_range_seconds_count[6h])',
          intervalFactor = 1,
          interval='$interval',
        )
      ),
      gridPos = {
        "h": 2,
        "w": 3,
        "x": 0,
        "y": 7
      }
    )//108 singlestat
    .addPanel(
      singlestat.new(
        'Samples Per Chunk',//title
        format='short',
        decimals=null,
        datasource='Prometheus',
        valueName='current',
        thresholds='',
        colorValue=false,
        sparklineShow=true,
        colors=[
          "#299c46",
          "rgba(237, 129, 40, 0.89)",
          "#d44a3a"
        ],
        height='125px',
        interval=null,
        valueFontSize='50%',
      )
      .addTarget(
        prometheus.target(
          'rate(prometheus_tsdb_compaction_chunk_samples_sum[6h])/rate(prometheus_tsdb_compaction_chunk_samples_count[6h])',
          intervalFactor = 2,
          interval='$interval',
          legendFormat='series',
        )
      ),
      gridPos = {
        "h": 2,
        "w": 3,
        "x": 3,
        "y": 7
      }
    )//109 singlestat
    .addPanel(
      singlestat.new(
        'Avg Chunk Size',//title
        format='bytes',
        decimals=null,
        datasource='Prometheus',
        valueName='current',
        thresholds='',
        colorValue=false,
        sparklineShow=true,
        colors=[
          "#299c46",
          "rgba(237, 129, 40, 0.89)",
          "#d44a3a"
        ],
        height='125px',
        interval=null,
        valueFontSize='50%',
      )
      .addTarget(
        prometheus.target(
          'rate(prometheus_tsdb_compaction_chunk_size_bytes_sum[6h])/rate(prometheus_tsdb_compaction_chunk_size_bytes_count[6h])',
          intervalFactor = 2,
          legendFormat='Series',
        )
      ),
      gridPos = {
        "h": 2,
        "w": 3,
        "x": 6,
        "y": 7
      }
    )//110 singlestat
    .addPanel(
      singlestat.new(
        'Bytes/Sample',//title
        format='decbytes',
        decimals=1,
        datasource='Prometheus',
        valueName='current',
        thresholds='',
        colorValue=false,
        sparklineShow=true,
        colors=[
          "#299c46",
          "rgba(237, 129, 40, 0.89)",
          "#d44a3a"
        ],
        height='125px',
        interval=null,
        valueFontSize='50%',
      )
      .addTarget(
        prometheus.target(
          '(rate(prometheus_tsdb_compaction_chunk_size_bytes_sum[6h])/rate(prometheus_tsdb_compaction_chunk_size_bytes_count[6h]))/
          (rate(prometheus_tsdb_compaction_chunk_samples_sum[6h])/rate(prometheus_tsdb_compaction_chunk_samples_count[6h]))',
          intervalFactor=1,
          interval='$interval',
          legendFormat='series',
        )
      ),
      gridPos = {
        "h": 2,
        "w": 3,
        "x": 9,
        "y": 7
      }
    )//111 singlestat
    .addPanel(
      singlestat.new(
        'Head Block Size',//title
        description='Head Block Size (Estimated)',
        format='bytes',
        decimals=null,
        datasource='Prometheus',
        valueName='current',
        thresholds='',
        colorValue=false,
        sparklineShow=true,
        colors=[
          "#299c46",
          "rgba(237, 129, 40, 0.89)",
          "#d44a3a"
        ],
        height='125px',
        interval=null,
        valueFontSize='50%',
      )
      .addTarget(
        prometheus.target(
          'rate(prometheus_tsdb_compaction_chunk_size_bytes_sum[6h])/
          rate(prometheus_tsdb_compaction_chunk_size_bytes_count[6h])*
          (max_over_time(prometheus_tsdb_head_chunks[$interval]) or max_over_time(prometheus_tsdb_head_chunks[5m]))',
          intervalFactor=2,
          interval='$interval',
          legendFormat='series',
        )
      ),
      gridPos = {
        "h": 2,
        "w": 3,
        "x": 12,
        "y": 7
      }
    )//113 singlestat
    .addPanel(
      singlestat.new(
        'Avg Compaction Time',//title
        format='s',
        decimals=2,
        datasource='Prometheus',
        valueName='current',
        thresholds='300,3600',
        colorValue=false,
        sparklineShow=true,
        colors=[
            "#d44a3a",
           "rgba(237, 129, 40, 0.89)",
           "#299c46"
        ],
        height='125px',
        interval=null,
        valueFontSize='50%',
      )
      .addTarget(
        prometheus.target(
          'rate(prometheus_tsdb_compaction_duration_seconds_sum[6h])/rate(prometheus_tsdb_compaction_duration_seconds_count[6h])',
          intervalFactor=1,
        )
      ),
      gridPos={
        "h": 2,
        "w": 3,
        "x": 15,
        "y": 7
      }
    )//114 singlestat
    .addPanel(
      singlestat.new(
        'WAL Fsync Time',
        format='s',
        decimals=2,
        datasource='Prometheus',
        valueName='current',
        thresholds='300,3600',
        colorValue=false,
        sparklineShow=true,
        colors=[
            "#d44a3a",
           "rgba(237, 129, 40, 0.89)",
           "#299c46"
        ],
        height='125px',
        interval=null,
        valueFontSize='50%',
      )
      .addTarget(
        prometheus.target(
          'rate(prometheus_tsdb_wal_fsync_duration_seconds_sum[6h])/rate(prometheus_tsdb_wal_fsync_duration_seconds_count[6h])',
          intervalFactor=1,
        )
      ),
      gridPos={
        "h": 2,
        "w": 3,
        "x": 18,
        "y": 7
      }
    )//115 singlestat
    .addPanel(
      singlestat.new(
        'Head GC Latency',
        format='s',
        decimals=2,
        datasource='Prometheus',
        valueName='current',
        thresholds='300,3600',
        colorValue=false,
        sparklineShow=true,
        colors=[
            "#d44a3a",
           "rgba(237, 129, 40, 0.89)",
           "#299c46"
        ],
        height='125px',
        interval=null,
        valueFontSize='50%',
      )
      .addTarget(
        prometheus.target(
          'rate(prometheus_tsdb_head_gc_duration_seconds_sum[6h])/rate(prometheus_tsdb_head_gc_duration_seconds_count[6h])',
          intervalFactor=1,
        )
      ),
      gridPos={
        "h": 2,
        "w": 3,
        "x": 21,
        "y": 7
      }
    )//116 singlestat
    .addPanel(
      graphPanel.new(
        'Active Data Blocks',//title
        fill=0,
        linewidth=2,
        datasource='Prometheus',
        pointradius=2,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        editable=true,
        height='250px',
        minY1='0',
      )
      .addTarget(
          prometheus.target(
            'max_over_time(prometheus_tsdb_blocks_loaded[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Active (Loaded) Data Blocks',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 9
      }
    )//66 graph
    .addPanel(
      graphPanel.new(
        'Head Block',//title
        fill=0,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=2,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        editable=true,
        height='250px',
        min='0',
        formatY2='decbytes',
      )
      .addSeriesOverride({
              "alias": "Size",
              "yaxis": 2
            })
      .addSeriesOverride({
              "alias": "Size (Estimated)",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'max_over_time(prometheus_tsdb_head_chunks[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Chunks',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(prometheus_tsdb_head_series[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Series',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(prometheus_tsdb_compaction_chunk_size_sum[6h])/rate(prometheus_tsdb_compaction_chunk_size_count[6h])*(max_over_time(prometheus_tsdb_head_chunks[$interval]) )',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Size (Estimated)',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 9
      }
    )//105 graph
    .addPanel(
      graphPanel.new(
        'Chunk Activity',//title
        fill=0,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        nullPointMode="null as zero",
        pointradius=2,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        editable=true,
        height='250px',
        minY1='0',
      )
      .addTarget(
          prometheus.target(
            'rate(prometheus_tsdb_head_chunks_created_total[$interval]) or irate(prometheus_tsdb_head_chunks_created_total[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Chunks Created',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(prometheus_tsdb_head_chunks_removed_total[$interval]) or irate(prometheus_tsdb_head_chunks_removed_total[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Chunks Removed',
          )
      ),
      gridPos={
            "h": 7,
            "w": 12,
            "x": 0,
            "y": 16
      }
    )//106 graph
    .addPanel(
      graphPanel.new(
        'Reload block data from disk',//title
        fill=0,
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
        editable=true,
        height='250px',
        minY1='0',
        aliasColors={
            "failed": "#bf1b00",
            "failed reload": "#bf1b00"
          },
      )
      .addTarget(
          prometheus.target(
            '(rate(prometheus_tsdb_reloads_total[$interval]) - rate(prometheus_tsdb_reloads_failures_total[$interval])) or (irate(prometheus_tsdb_reloads_total[5m]) - irate(prometheus_tsdb_reloads_failures_total[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='success',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(prometheus_tsdb_reloads_failures_total[$interval]) or irate(prometheus_tsdb_reloads_failures_total[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='failed',
          )
      ),
      gridPos={
            "h": 7,
            "w": 12,
            "x": 12,
            "y": 16
      }
    )//73 graph
    .addPanel(
      graphPanel.new(
        'Compactions',//title
        fill=0,
        decimals=2,
        linewidth=2,
        points=true,
        lines=false,
        datasource='Prometheus',
        pointradius=2,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        editable=true,
        height='250px',
        minY1='0',
        aliasColors={
            "Compactions Failed": "#bf1b00",
            "Compactions Performed": "#1f78c1",
            "failed": "#bf1b00",
            "failed reload": "#bf1b00"
          },
      )
      .addTarget(
          prometheus.target(
            'increase(prometheus_tsdb_compactions_total[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Compactions Performed',
          )
      )
      .addTarget(
          prometheus.target(
            'increase(prometheus_tsdb_compactions_failed_total[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Compactions Failed',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 23
      }
    )//107 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 6,
    },
    style=null,
)//76 row
.addPanel(
    row.new(
      title='Scraping',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'Ingestion',//title
        fill=0,
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
        editable=true,
        value_type='cumulative',
        min=0,
        formatY2='ops',
        aliasColors={
            "Samples Ingested": "#629e51",
            "Scrapes Performed": "#6ED0E0"
          },
      )
      .addSeriesOverride({
              "alias": "Scrapes Performed",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'sum(rate(prometheus_target_interval_length_seconds_count[$interval])) or sum(irate(prometheus_target_interval_length_seconds_count[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Scrapes Performed',
            step=60,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(prometheus_tsdb_head_samples_appended_total[$interval]) or irate(prometheus_tsdb_head_samples_appended_total[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Samples appended in the head block',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 8
      }
    )//2 graph
    .addPanel(
      graphPanel.new(
        'Prometheus Targets',//title
        fill=0,
        decimals=2,
        linewidth=1,
        datasource='Prometheus',
        pointradius=2,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        editable=true,
        min=0,
        aliasColors={
            "Count": "#EAB839",
            "Min Successfully Scraped Targets": "#E24D42"
          },
      )
      .addSeriesOverride({
              "alias": "Min Successfully Scraped Targets",
              "lines": false,
              "pointradius": 1,
              "points": true
            })
      .addTarget(
          prometheus.target(
            'count(up)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Targets Configured',
            step=60,
          )
      )
      .addTarget(
          prometheus.target(
            'sum(avg_over_time(up[$interval])) or  sum(avg_over_time(up[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Avg Succesfully Scraped Targets',
            step=60,
          )
      )
      .addTarget(
          prometheus.target(
            'sum(min_over_time(up[$interval])) or  sum(min_over_time(up[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Min Successfully Scraped Targets',
            step=60,
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 8
      }
    )//12 graph
    .addPanel(
      graphPanel.new(
        'Scraped Target by Job',//title
        fill=0,
        decimals=0,
        linewidth=1,
        datasource='Prometheus',
        pointradius=1,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        min=0,
        decimalsY1=0,
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Percent of Time Checkpoint is Active",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'sum by (job) (label_replace(
            sum(avg_over_time(up{service_type="mysql"}[$interval])) by (job,service_name) or
            sum(avg_over_time(up{service_type="mysql"}[5m])) by (job,service_name),
            "job", "$2", "job", "mysqld_(.*)_(.*)"))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='mysqld_exporter_{{job}}',
            step=60,
          )
      )
      .addTarget(
          prometheus.target(
            'sum by (job) (label_replace(
            (sum(avg_over_time(up{service_type!="mysql",instance!="pmm-server"}[$interval])) by (job,node_name) or
            sum(avg_over_time(up{service_type!="mysql",instance!="pmm-server"}[5m])) by (job,node_name)),
            "job", "$1", "job", "(.*)_agent_(.*)"))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{job}}',
          )
      )
      .addTarget(
          prometheus.target(
            'sum(avg_over_time(up{instance="pmm-server"}[$interval])) by (job) or sum(avg_over_time(up{instance="pmm-server"}[5m])) by (job)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{job}}',
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 0,
           "y": 15
      }
    )//24 graph
    .addPanel(
      graphPanel.new(
        'Scrape Time by Job',//title
        fill=0,
        decimals=2,
        linewidth=1,
        datasource='Prometheus',
        pointradius=1,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        min=0,
        formatY1='s',
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'label_replace(
            (avg(avg_over_time(scrape_duration_seconds{service_type="mysql"}[$interval])) by (job,service_name) or
            avg(avg_over_time(scrape_duration_seconds{service_type="mysql"}[5m])) by (job,service_name)),
            "job", "$2", "job", "mysqld_(.*)_(.*)")',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{service_name}} - mysqld_exporter - {{job}}',
            step=60,
          )
      )
      .addTarget(
          prometheus.target(
            'label_replace(
            (avg(avg_over_time(scrape_duration_seconds{service_type!="mysql",instance!="pmm-server"}[$interval])) by (job,node_name) or
            avg(avg_over_time(scrape_duration_seconds{service_type!="mysql",instance!="pmm-server"}[5m])) by (job,node_name)),
            "job", "$1", "job", "(.*)_agent_(.*)")',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{node_name}} - {{job}}',
          )
      )
      .addTarget(
          prometheus.target(
            'avg(avg_over_time(scrape_duration_seconds{instance="pmm-server"}[$interval])) by (job,service_name) or
            avg(avg_over_time(scrape_duration_seconds{instance="pmm-server"}[5m])) by (job,service_name)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='PMM Server - {{job}}',
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 12,
           "y": 15
      }
    )//42 graph
    .addPanel(
      graphPanel.new(
        'Scraped Target by Instance',//title
        fill=0,
        decimals=0,
        linewidth=1,
        datasource='Prometheus',
        pointradius=1,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        min=0,
        decimalsY1=0,
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Percent of Time Checkpoint is Active",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'sum(avg_over_time(up{instance!="pmm-server",node_name!="PMM Server"}[$interval])) by (node_name) or
            sum(avg_over_time(up{instance!="pmm-server",node_name!="PMM Server"}[5m])) by (node_name)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{node_name}}',
            step=60,
          )
      )
      .addTarget(
          prometheus.target(
            'sum(
            sum(avg_over_time(up{node_name="PMM Server"}[$interval])) by (node_name) or
            sum(avg_over_time(up{instance="pmm-server"}[$interval])) by (instance) or
            sum(avg_over_time(up{node_name="PMM Server"}[5m])) by (node_name) or
            sum(avg_over_time(up{instance="pmm-server"}[5m])) by (instance)
            )',
            interval='$interval',
            intervalFactor=1,
            legendFormat='PMM Server',
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 0,
           "y": 22
      }
    )//25 graph
    .addPanel(
      graphPanel.new(
        'Scrape Time by Instance',//title
        fill=0,
        decimals=2,
        linewidth=1,
        datasource='Prometheus',
        pointradius=1,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        min=0,
        formatY1='s',
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'avg(avg_over_time(scrape_duration_seconds{instance!="pmm-server",node_name!="PMM Server"}[$interval])) by (node_name) or
            avg(avg_over_time(scrape_duration_seconds{instance!="pmm-server",node_name!="PMM Server"}[5m])) by (node_name)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{node_name}}',
            step=60,
          )
      )
      .addTarget(
          prometheus.target(
            'avg(avg_over_time(scrape_duration_seconds{node_name="PMM Server"}[$interval]) or
            avg_over_time(scrape_duration_seconds{instance="pmm-server"}[$interval])) or
            avg(avg_over_time(scrape_duration_seconds{node_name="PMM Server"}[5m]) or
            avg_over_time(scrape_duration_seconds{instance="pmm-server"}[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='PMM Server',
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 12,
           "y": 22
      }
    )//43 graph
    .addPanel(
      graphPanel.new(
        'Scrapes by Target Frequency',//title
        fill=0,
        decimals=2,
        linewidth=1,
        datasource='Prometheus',
        pointradius=1,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        min=0,
        formatY1='ops',
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Percent of Time Checkpoint is Active",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'rate(prometheus_target_interval_length_seconds_count[$interval]) or irate(prometheus_target_interval_length_seconds_count[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Rate of {{interval}} scrapes',
            step=60,
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 0,
           "y": 29
      }
    )//26 graph
    .addPanel(
      graphPanel.new(
        'Scrape Frequency Versus Target',//title
        fill=0,
        decimals=2,
        linewidth=1,
        points=true,
        lines=false,
        datasource='Prometheus',
        pointradius=1,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        min=0,
        formatY1='s',
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Percent of Time Checkpoint is Active",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            '(rate(prometheus_target_interval_length_seconds_sum[$interval]) / rate(prometheus_target_interval_length_seconds_count[$interval])) or (irate(prometheus_target_interval_length_seconds_sum[5m]) / irate(prometheus_target_interval_length_seconds_count[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Actual  {{interval}} scrape interval  length',
            step=60,
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 12,
           "y": 29
      }
    )//27 graph
    .addPanel(
      graphPanel.new(
        'Scraping Time Drift',//title
        fill=0,
        decimals=2,
        linewidth=1,
        bars=true,
        lines=false,
        datasource='Prometheus',
        pointradius=1,
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
        min=0,
        logBase1Y=2,
        formatY1='s',
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'time() - node_time_seconds',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{node_name}}',
            step=60,
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 0,
           "y": 36
      }
    )//41 graph
    .addPanel(
      graphPanel.new(
        'Prometheus Scrape Interval Variance',//title
        fill=0,
        decimals=2,
        linewidth=1,
        datasource='Prometheus',
        pointradius=1,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        min=0,
        format='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Percent of Time Checkpoint is Active",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            '(sum(prometheus_target_interval_length_seconds{instance="pmm-server",interval="1s",job="prometheus",quantile="0.99"}) by () -
            sum(prometheus_target_interval_length_seconds{instance="pmm-server",interval="1s",job="prometheus",quantile="0.01"}) by ())/1',
            interval='$interval',
            intervalFactor=1,
            legendFormat='1sec  Target Interval Variance',
            step=60,
          )
      )
      .addTarget(
          prometheus.target(
            '(sum(prometheus_target_interval_length_seconds{instance="pmm-server",interval="5s",job="prometheus",quantile="0.99"}) by () -
            sum(prometheus_target_interval_length_seconds{instance="pmm-server",interval="5s",job="prometheus",quantile="0.01"}) by ())/5',
            interval='$interval',
            intervalFactor=1,
            legendFormat='5sec  Target Interval Variance',
          )
      )
      .addTarget(
          prometheus.target(
            '(sum(prometheus_target_interval_length_seconds{instance="pmm-server",interval="1m0s",job="prometheus",quantile="0.99"}) by () -
            sum(prometheus_target_interval_length_seconds{instance="pmm-server",interval="1m0s",job="prometheus",quantile="0.01"}) by ())/60',
            interval='$interval',
            intervalFactor=1,
            legendFormat='1min  Target Interval Variance',
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 12,
           "y": 36
      }
    )//40 graph
    .addPanel(
      graphPanel.new(
        'Slowest Jobs',//title
        fill=0,
        decimals=2,
        linewidth=1,
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        min=0,
        formatY1='s',
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Percent of Time Checkpoint is Active",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'topk(10,label_join((max_over_time(scrape_duration_seconds[$interval]) or max_over_time(scrape_duration_seconds[5m])), "node_name", ",","instance"))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{job}} at {{node_name}}',
            hide=true,
            step=60,
          )
      )
      .addTarget(
          prometheus.target(
            'topk(10,(label_join((max_over_time(scrape_duration_seconds{instance="pmm-server"}[$interval]) or
            max_over_time(scrape_duration_seconds{instance="pmm-server"}[5m])), "node_name", ",","instance") or
            label_replace((max_over_time(scrape_duration_seconds{service_type!="mysql",instance!="pmm-server"}[$interval]) or
            max_over_time(scrape_duration_seconds{service_type!="mysql",instance!="pmm-server"}[5m])),"job", "$1", "job", "(.*)_agent_(.*)") or
            label_replace((max_over_time(scrape_duration_seconds{service_type="mysql"}[$interval]) or
            max_over_time(scrape_duration_seconds{service_type="mysql"}[5m])),"job", "mysqld_exporter_$3", "job", "(.*)_agent_id_(.*)_(.*)")
            ))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{job}} at {{node_name}}',
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 0,
           "y": 43
      }
    )//44 graph
    .addPanel(
      graphPanel.new(
        'Largest Samples Jobs',//title
        fill=0,
        decimals=2,
        linewidth=1,
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        min=0,
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Percent of Time Checkpoint is Active",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'topk(10,max_over_time(scrape_samples_scraped[$interval]) or max_over_time(scrape_samples_seconds[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{job}} at {{instance}}',
            step=60,
            hide=true,
          )
      )
      .addTarget(
          prometheus.target(
            'topk(10,(label_join((max_over_time(scrape_samples_scraped{instance="pmm-server"}[$interval]) or
            max_over_time(scrape_samples_scraped{instance="pmm-server"}[5m])), "node_name", ",","instance") or
            label_replace((max_over_time(scrape_samples_scraped{service_type!="mysql",instance!="pmm-server"}[$interval]) or
            max_over_time(scrape_samples_scraped{service_type!="mysql",instance!="pmm-server"}[5m])),"job", "$1", "job", "(.*)_agent_(.*)") or
            label_replace((max_over_time(scrape_samples_scraped{service_type="mysql"}[$interval]) or
            max_over_time(scrape_samples_scraped{service_type="mysql"}[5m])),"job", "mysqld_exporter_$3", "job", "(.*)_agent_id_(.*)_(.*)")
            ))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{job}} - {{node_name}}',
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 12,
           "y": 43
      }
    )//45 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 7,
    },
    style=null,
)//77 row
.addPanel(
    row.new(
      title='Queries',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'Prometheus Queries',//title
        fill=0,
        decimals=2,
        linewidth=1,
        datasource='Prometheus',
        pointradius=1,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        min=0,
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Max Queries Active": "#E24D42",
            "Maximum Queries Permitted": "#890F02",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Max Queries Active",
              "lines": false,
              "pointradius": 1,
              "points": true
            })
      .addTarget(
          prometheus.target(
            'avg_over_time(prometheus_engine_queries[$interval]) or avg_over_time(prometheus_engine_queries[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Avg Queries Active',
            step=60,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(prometheus_engine_queries[$interval]) or max_over_time(prometheus_engine_queries[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Max Queries Active',
            step=60,
          )
      )
      .addTarget(
          prometheus.target(
            'prometheus_engine_queries_concurrent_max',
            intervalFactor=2,
            legendFormat='Maximum Queries Permitted',
            step=40,
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 9,
      }
    )//28 graph
    .addPanel(
      graphPanel.new(
        'Prometheus Query Execution',//title
        fill=0,
        decimals=2,
        linewidth=1,
        datasource='Prometheus',
        pointradius=1,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        min=0,
        formatY1='ops',
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Max Queries Active": "#E24D42",
            "Maximum Queries Permitted": "#890F02",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Max Queries Active",
              "lines": false,
              "pointradius": 1,
              "points": true
            })
      .addTarget(
          prometheus.target(
            'rate(prometheus_engine_query_duration_seconds_count[$interval]) or irate(prometheus_engine_query_duration_seconds_count[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{slice}} - Executed',
            step=60,
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 9,
      }
    )//29 graph
    .addPanel(
      graphPanel.new(
        'Prometheus Query Execution Latency',//title
        fill=0,
        decimals=2,
        linewidth=1,
        datasource='Prometheus',
        pointradius=1,
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
        min=0,
        formatY1='s',
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Max Queries Active": "#E24D42",
            "Maximum Queries Permitted": "#890F02",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Max Queries Active",
              "lines": false,
              "pointradius": 1,
              "points": true
            })
      .addTarget(
          prometheus.target(
            '(rate(prometheus_engine_query_duration_seconds_sum[$interval])/rate(prometheus_engine_query_duration_seconds_count[$interval])) or (irate(prometheus_engine_query_duration_seconds_sum[$interval])/irate(prometheus_engine_query_duration_seconds_count[$interval]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{slice}} - Avg Time',
            step=60,
          )
      ),
      gridPos={
          "h": 7,
            "w": 12,
            "x": 0,
            "y": 16
      }
    )//30 graph
    .addPanel(
      graphPanel.new(
        'Prometheus Query Execution Load',//title
        fill=0,
        decimals=2,
        linewidth=1,
        datasource='Prometheus',
        pointradius=1,
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
        min=0,
        formatY2='percentunit',
        aliasColors={
            "Count": "#EAB839",
            "Max Queries Active": "#E24D42",
            "Maximum Queries Permitted": "#890F02",
            "Rushed Mode High Watermark": "#BF1B00",
            "Rushed Mode Low Watermark": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Max Queries Active",
              "lines": false,
              "pointradius": 1,
              "points": true
            })
      .addTarget(
          prometheus.target(
            'rate(prometheus_engine_query_duration_seconds_sum[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{slice}} - Load',
            step=60,
          )
      ),
      gridPos={
          "h": 7,
            "w": 12,
            "x": 12,
            "y": 16
      }
    )//39 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 8,
    },
    style=null,
)//78 row
.addPanel(
    row.new(
      title='Network',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'HTTP Requests duration by Handler',//title
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
        legend_rightSide=true,
        editable=true,
        decimalsY1=2,
        formatY1='s',
        logBase1Y=2,
      )
      .addTarget(
          prometheus.target(
            'rate(prometheus_http_request_duration_seconds_sum[$interval]) or irate(prometheus_http_request_duration_seconds_sum[$interval])\n',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{handler}}',
          )
      ),
      gridPos={
            "h": 7,
            "w": 24,
            "x": 0,
            "y": 10
      }
    )//90 graph
    .addPanel(
      graphPanel.new(
        'HTTP Response Average Size by Handler',//title
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
        legend_rightSide=true,
        editable=true,
        decimalsY1=2,
        formatY1='bytes',
        logBase1Y=2,
      )
      .addTarget(
          prometheus.target(
            'rate(prometheus_http_response_size_bytes_sum[$interval]) or\nirate(prometheus_http_response_size_bytes_sum[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{handler}}',
          )
      ),
      gridPos={
            "h": 7,
            "w": 24,
            "x": 0,
            "y": 17
      }
    )//91 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 9,
    },
    style=null,
)//79 row
.addPanel(
    row.new(
      title='Time Series Information',
      collapse=true,
    )
    .addPanel(
        tablePanel.new(
          title='Top 10 metrics by time series count',
          columns=[
            {
              "text": "Current",
              "value": "current"
            }
          ],
          datasource='Prometheus',
          fontSize='100%',
          height='420px',
          scroll=false,
          showHeader=true,
          sort={
            "col":1,
            "desc":true,
          },
          hideTimeOverride=true,
          timeFrom='5m',
          transform='timeseries_aggregations',
        )
        .addTarget(
          prometheus.target(
            'topk(10, count({__name__=~".+"})  by (__name__))',
            intervalFactor = 2,
            legendFormat="{{ __name__ }}",
            interval='5m',
            step=600,
         )
         ),
        gridPos={
          "h": 11,
          "w": 12,
          "x": 0,
          "y": 53
          }
    )//13 table
    .addPanel(
        tablePanel.new(
          title='Top 10 hosts by time series count',
          columns=[
            {
              "text": "Current",
              "value": "current"
            }
          ],
          datasource='Prometheus',
          fontSize='100%',
          height='420px',
          scroll=false,
          showHeader=true,
          sort={
            "col":3,
            "desc":true,
          },
          hideTimeOverride=true,
          timeFrom='5m',
        )
        .addStyle({
              "alias": "",
              "colorMode": null,
              "colors": [
                "rgba(245, 54, 54, 0.9)",
                "rgba(237, 129, 40, 0.89)",
                "rgba(50, 172, 45, 0.97)"
              ],
              "dateFormat": "YYYY-MM-DD HH:mm:ss",
              "decimals": 2,
              "mappingType": 1,
              "pattern": "Time",
              "thresholds": [],
              "type": "hidden",
              "unit": "short"
            })
        .addTarget(
          prometheus.target(
            'topk(10, sum by (node_name) (count({__name__=~".+",instance!="pmm-server"})  by (node_name) or\ncount({__name__=~".+",instance="pmm-server"})  by (instance)))',
            intervalFactor = 2,
            interval='5m',
            legendFormat="{{ instance }}",
            hide=true,
            instant=true,
            step=600,
            format='table',
         )
        )
        .addTarget(
          prometheus.target(
            'topk(10, sum by (node_name) (count({__name__=~".+",instance!="pmm-server"})  by (node_name) or
            label_replace(
            label_join(count({__name__=~".+",instance="pmm-server"})  by (instance,node_name), "node_name", ",","instance"),
            "node_name", "PMM Server", "node_name", "pmm-server")
            ))',
            intervalFactor = 1,
            interval='5m',
            legendFormat="{{ instance }}",
            hide=false,
            instant=true,
            format='table',
         )
        ),
        gridPos={
          "h": 11,
          "w": 12,
          "x": 12,
          "y": 53
          }
    )//14 table
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 10,
    },
    style=null,
)//80 row
.addPanel(
    row.new(
      title='System Level Metrics',
      collapse=true,
    )
    .addPanel(
      pmmSinglestat.new(
        'CPU Busy',//title
        format='percent',
        decimals=0,
        datasource='Prometheus',
        valueName='current',
        thresholds='70,90',
        colorValue=true,
        colors=[
            "rgba(50, 172, 45, 0.97)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(245, 54, 54, 0.9)"
        ],
        sparklineShow=true,
        sparklineFull=true,
        sparklineMaxValue=0,
        interval='$interval',
        height='50',
        prefixFontSize='80%',
        postfixFontSize='80%',
        valueFontSize='150%',
        valueMaps=[],
        links=[
            {
              "dashUri": "db/system-overview",
              "dashboard": "System Overview",
              "includeVars": true,
              "keepTime": true,
              "params": "var-host=pmm-server",
              "targetBlank": true,
              "title": "System Overview",
              "type": "dashboard"
            }
          ],
      )
      .addTarget(
        prometheus.target(
          'clamp_max(avg by (instance) (sum by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name="PMM Server",mode!="idle",mode!="iowait"}[$interval]),1)) or  (clamp_max(irate(node_cpu_seconds_total{node_name="PMM Server",mode!="idle",mode!="iowait"}[5m]),1)) )),1) *100',
          intervalFactor = 1,
          interval='$interval',
          metric='node_mem',
          calculatedInterval='10m',
          step=300,
        )
      ),
      gridPos = {
          "h": 3,
          "w": 4,
          "x": 0,
          "y": 12
      }
    )//46 pmm-singlestat
    .addPanel(
      pmmSinglestat.new(
        'Mem Avail',//title
        format='percent',
        decimals=0,
        datasource='Prometheus',
        valueName='current',
        thresholds='10,20',
        colorValue=true,
        colors=[
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)"
        ],
        sparklineShow=true,
        interval='$interval',
        height='50',
        prefixFontSize='80%',
        postfixFontSize='50%',
        valueFontSize='150%',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          '(node_memory_MemAvailable_bytes{node_name="PMM Server"} or (node_memory_MemFree_bytes{node_name="PMM Server"} + node_memory_Buffers_bytes{node_name="PMM Server"} + node_memory_Cached_bytes{node_name="PMM Server"})) / node_memory_MemTotal_bytes{node_name="PMM Server"} * 100',
          intervalFactor = 1,
          interval='$interval',
          metric='node_mem',
          calculatedInterval='10m',
          step=300,
        )
      ),
      gridPos = {
          "h": 3,
          "w": 4,
          "x": 4,
          "y": 12
      }
    )//47 pmm-singlestat
    .addPanel(
      singlestat.new(
        'Disk Reads',//title
        format='Bps',
        editable=true,
        decimals=1,
        datasource='Prometheus',
        valueName='current',
        thresholds='10000000,100000000',
        sparklineShow=true,
        sparklineFull=true,
        colorValue=true,
        colors=[
          "#0a437c",
            "#1f78c1",
            "#5195ce"
        ],
        interval='$interval',
        height='50',
        prefixFontSize='30%',
        postfixFontSize='30%',
        valueFontSize='50%',
        valueMaps=[],
        links=[
            {
              "dashUri": "db/disk-performance",
              "dashboard": "Disk Performance",
              "includeVars": true,
              "keepTime": true,
              "params": "var-host=pmm-server",
              "targetBlank": true,
              "title": "Disk Performance",
              "type": "dashboard"
            }
          ],
      )
      .addTarget(
        prometheus.target(
          'rate(node_vmstat_pgpgin{node_name="PMM Server"}[$interval]) * 1024 or irate(node_vmstat_pgpgin{node_name="PMM Server"}[5m]) * 1024',
          intervalFactor = 1,
          interval='$interval',
          metric='node_mem',
          calculatedInterval='10m',
          step=300,
        )
      ),
      gridPos = {
        "h": 3,
        "w": 4,
        "x": 8,
        "y": 12
      }
    )//48 singlestat
    .addPanel(
      singlestat.new(
        'Disk Writes',//title
        format='Bps',
        editable=true,
        decimals=1,
        datasource='Prometheus',
        valueName='current',
        thresholds='10000000,100000000',
        sparklineShow=true,
        sparklineFull=true,
        colorValue=true,
        colors=[
          "#6d1f62",
          "#962d82",
          "#ba43a9"
        ],
        interval='$interval',
        height='50',
        prefixFontSize='30%',
        postfixFontSize='30%',
        valueFontSize='50%',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'rate(node_vmstat_pgpgout{node_name="PMM Server"}[$interval]) * 1024 or irate(node_vmstat_pgpgout{node_name="PMM Server"}[5m]) * 1024',
          intervalFactor = 1,
          interval='$interval',
          metric='node_mem',
          calculatedInterval='10m',
          step=300,
        )
      ),
      gridPos={
        "h": 3,
        "w": 4,
        "x": 12,
        "y": 12
      }
    )//49 singlestat
    .addPanel(
      singlestat.new(
        'Network IO',//title
        format='Bps',
        editable=true,
        decimals=1,
        datasource='Prometheus',
        valueName='current',
        thresholds='',
        sparklineShow=true,
        sparklineFull=true,
        colorValue=true,
        colors=[
          "rgba(245, 54, 54, 0.9)",
            "#fce2de",
            "rgba(50, 172, 45, 0.97)"
        ],
        interval='$interval',
        height='50',
        prefixFontSize='30%',
        postfixFontSize='30%',
        valueFontSize='50%',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          '(sum(rate(node_network_receive_bytes_total{node_name="PMM Server", device!="lo"}[$interval]) or irate(node_network_receive_bytes_total{node_name="PMM Server", device!="lo"}[5m]))) + (sum(rate(node_network_transmit_bytes_total{node_name="PMM Server", device!="lo"}[$interval]) or irate(node_network_transmit_bytes_total{node_name="PMM Server", device!="lo"}[5m])))',
          intervalFactor = 1,
          interval='$interval',
          metric='node_mem',
          calculatedInterval='10m',
          step=300,
        )
      ),
      gridPos={
        "h": 3,
        "w": 4,
        "x": 16,
        "y": 12
      }
    )//50 singlestat
    .addPanel(
      singlestat.new(
        'Sys Uptime',//title
        colorPostfix=true,
        format='s',
        editable=true,
        decimals=1,
        datasource='Prometheus',
        valueName='current',
        thresholds='300,3600',
        colorValue=true,
        colors=[
          "rgba(245, 54, 54, 0.9)",
         "rgba(237, 129, 40, 0.89)",
         "rgba(50, 172, 45, 0.97)"
        ],
        interval='$interval',
        height='50',
        prefixFontSize='20%',
        postfix='s',
        postfixFontSize='50%',
        valueFontSize='50%',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'node_time_seconds{node_name="PMM Server"} - node_boot_time_seconds{node_name="PMM Server"}',
          intervalFactor = 1,
          interval='5m',
          calculatedInterval='10m',
          step=300,
        )
      ),
      gridPos={
        "h": 3,
        "w": 4,
        "x": 20,
        "y": 12
      }
    )//51 singlestat
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 11,
    },
    style=null,
)//81 row
.addPanel(
    row.new(
      title='PMM Server Logs',
      collapse=true,
    )
    .addPanel(
      text.new(
        content='<br><br>To simplify problem detection, you can download <a href="/managed/logs.zip">server logs</a>. Please include this file if you are submitting a bug report',
        mode='html',
      ),
      gridPos={
        "h": 3,
       "w": 24,
       "x": 0,
       "y": 13
          }
    )//84 text
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 12,
    },
    style=null,
)//82 row
