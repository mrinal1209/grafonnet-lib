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
local tablePanel = grafana.tablePanel;
local pmmSinglestat = grafana.pmmSinglestat;

dashboard.new(
  'Prometheus Exporters Overview',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=10,
  tags=['Percona','Insight'],
  iteration=1555334980905,
  uid="gfz9QMHiz",
  timepicker = timepicker.new(
    hidden=false,
    collapse=false,
    enable=true,
    notice=false,
    now=true,
    status='Stable',
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
  'host',
  'Prometheus',
  'label_values({__name__=~"node_load1|process_start_time_seconds"}, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='regex values',
  multi=true,
  skipUrlSync=false,
  definition='label_values({__name__=~"node_load1|process_start_time_seconds"}, node_name)',
  includeAll=true,
  tagsQuery='up',
  tagValuesQuery='instance',
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(process_start_time_seconds{node_name=~"$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=0,
  multi=true,
  skipUrlSync=false,
  definition='label_values(process_start_time_seconds{node_name=~"$host"}, service_name)',
  includeAll=true,
  hide=2,
  ),
)
.addPanel(
    row.new(
      title='Prometheus Exporters Summary',
    ),
    gridPos={
    "h": 1,
    "w": 24,
    "x": 0,
    "y": 0,
    },
    style=null,
)//2217 row
.addPanel(
  pmmSinglestat.new(
    'Avg CPU Usage per Host',//title
    description='Shows the average CPU usage in percent per host for all exporters. An Exporter is a software library that provides metrics to PMM.\n\nNote that the CPU usage is only the CPU usage of the exporter itself. It does not include the additional resource usage that is required to produce metrics by the application or operating system.\n\nSee also:',
    format='percent',
    datasource='Prometheus',
    valueName='current',
    decimals=1,
    colorValue=true,
    thresholds='5,19',
    colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    postfixFontSize='80%',
    prefixFontSize='80%',
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        }
      ],
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'avg((sum(rate(process_cpu_seconds_total{job=~".*exporter.*",node_name=~"$host"}[$interval])) by (node_name) or
      sum(irate(process_cpu_seconds_total{job=~".*exporter.*",node_name=~"$host"}[5m])) by (node_name)) /
      count(node_cpu_seconds_total{mode="user",node_name=~"$host"}) by (node_name)) by ()*100',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
    "h": 3,
          "w": 6,
          "x": 0,
          "y": 1
  },
  style=null,
)//2230 singlestat
.addPanel(
  singlestat.new(
    'Avg Memory Usage per Host',//title
    description='Shows the Exporters average Memory usage per host. An Exporter is a software library that provides metrics to PMM.\n\nNote that the Memory usage is only the Memory usage of the exporter itself. It does not include the additional memory usage that is required to produce metrics by the application or operating system.\n\nSee also:',
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    colorValue=true,
    thresholds='50000000,100000000',
    colors=[
        "rgba(50, 172, 45, 0.97)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(245, 54, 54, 0.9)",
    ],
    height='125px',
    interval='$interval',
    prefixFontSize='80%',
    valueMaps=[],
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        }
      ],
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'avg(sum(process_resident_memory_bytes{job=~".*exporter.*",node_name=~"$host"}) by (node_name))',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      step=300,
      metric='node_mem',
    )
  ),
  gridPos = {
    "h": 3,
    "w": 6,
    "x": 6,
    "y": 1
  },
  style=null,
)//1020 singlestat
.addPanel(
  singlestat.new(
    'Monitored Hosts',//title
    description='Shows the number of monitored hosts that are running Exporters. An Exporter is a software library that provides metrics to PMM.\n\nSee also:',
    format='short',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    colorValue=true,
    thresholds='512,800',
    colors=[
        "rgba(50, 172, 45, 0.97)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(245, 54, 54, 0.9)",
    ],
    height='125px',
    interval='$interval',
    prefixFontSize='80%',
    valueMaps=[],
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        }
      ],
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'count(count(process_open_fds{job=~".*exporter.*",node_name=~"$host"}) by (node_name))',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      step=300,
      metric='node_mem',
    )
  ),
  gridPos = {
    "h": 3,
    "w": 6,
    "x": 12,
    "y": 1
  },
  style=null,
)//1611 singlestat
.addPanel(
  singlestat.new(
    'Exporters Running',//title
    description='Shows the total number of Exporters running with this PMM Server instance. An Exporter is a software library that provides metrics to PMM.\n\nSee also:',
    format='short',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    colorValue=true,
    thresholds='512,800',
    colors=[
        "rgba(50, 172, 45, 0.97)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(245, 54, 54, 0.9)",
    ],
    height='125px',
    interval='$interval',
    prefixFontSize='80%',
    valueMaps=[],
    sparklineShow=true,
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'count(process_open_fds{job=~".*exporter.*",node_name=~"$host"}) ',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      step=300,
      metric='node_mem',
    )
  ),
  gridPos = {
    "h": 3,
    "w": 6,
    "x": 18,
    "y": 1
  },
  style=null,
)//1612 singlestat
.addPanel(
    row.new(
      title='Prometheus Exporters Resource Usage by Host',
    ),
    gridPos={
    "h": 1,
    "w": 24,
    "x": 0,
    "y": 4,
    },
    style=null,
)//2218 row
.addPanel(
  graphPanel.new(
    'CPU Usage',//title
    description="Plots the Exporters' CPU usage across each monitored host (by default, All hosts). An Exporter is a software library that provides metrics to PMM.\n\nSee also:",
    fill=1,
    linewidth=1,
    decimals=2,
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
    editable=true,
    formatY1='percent',
    minY1='0',
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        }
      ],
  )
  .addTarget(
      prometheus.target(
        '(sum(rate(process_cpu_seconds_total{job=~".*exporter.*",node_name=~"$host"}[$interval])) by (node_name) or
        sum(irate(process_cpu_seconds_total{job=~".*exporter.*",node_name=~"$host"}[5m])) by (node_name)) /
        count(node_cpu_seconds_total{job=~".*exporter.*",node_name=~"$host"}) by (node_name) *100',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{node_name}}',
      )
  ),
  gridPos={
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 5,
  },
  style=null,
)//1613 graph
.addPanel(
  graphPanel.new(
    'Memory Usage',//title
    description="Plots the Exporters' Memory usage across each monitored host (by default, All hosts). An Exporter is a software library that provides metrics to PMM.\n\nSee also:",
    fill=1,
    linewidth=1,
    decimals=2,
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
    editable=true,
    formatY1='bytes',
    minY1='0',
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        }
      ],
  )
  .addTarget(
      prometheus.target(
        'sum(process_resident_memory_bytes{job=~".*exporter.*",node_name=~"$host"}) by (node_name)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{node_name}}',
      )
  ),
  gridPos={
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 5,
  },
  style=null,
)//1914 graph
.addPanel(
    row.new(
      title='Prometheus Resource usage by Type',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 13,
    },
    style=null,
)//2219 row
.addPanel(
  graphPanel.new(
    'CPU Cores Used',//title
    description="Shows the Exporters' CPU Cores used for each type of Exporter. An Exporter is a software library that provides metrics to PMM.\n\nSee also:",
    fill=1,
    linewidth=1,
    decimals=2,
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
    editable=true,
    minY1='0',
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        }
      ],
  )
  .addTarget(
      prometheus.target(
        '(avg(rate(process_cpu_seconds_total{job=~".*exporter.*",node_name=~"$host"}[$interval])) by (agent_type) or
        avg(irate(process_cpu_seconds_total{job=~".*exporter.*",node_name=~"$host"}[5m])) by (agent_type))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{agent_type}}',
      )
  ),
  gridPos={
    "h": 9,
    "w": 12,
    "x": 0,
    "y": 14,
  },
  style=null,
)//1915 graph
.addPanel(
  graphPanel.new(
    'Memory Usage',//title
    description="Shows the Exporters' memory used for each type of Exporter. An Exporter is a software library that provides metrics to PMM.\n\nSee also:",
    fill=1,
    linewidth=1,
    decimals=2,
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
    editable=true,
    formatY1='bytes',
    minY1='0',
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        }
      ],
  )
  .addTarget(
      prometheus.target(
        'avg(process_resident_memory_bytes{job=~".*exporter.*",node_name=~"$host"}) by (agent_type)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{agent_type}}',
      )
  ),
  gridPos={
    "h": 9,
    "w": 12,
    "x": 12,
    "y": 14,
  },
  style=null,
)//2216 graph
.addPanel(
    row.new(
      title='',
      repeat='host',
    ),
    gridPos={
    "h": 1,
    "w": 24,
    "x": 0,
    "y": 23,
    },
    style=null,
)//2220 row
.addPanel(
  text.new(
    content='$host',
    height='95',
    mode='markdown',
    title='Host',
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        },
        {
          "dashUri": "db/system-overview",
          "dashboard": "System Overview",
          "includeVars": true,
          "keepTime": true,
          "targetBlank": true,
          "title": "System Overview",
          "type": "dashboard"
        }
      ],
  ),
  gridPos={
    "h": 3,
   "w": 5,
   "x": 0,
   "y": 24,
      },
  style=null,
)//162 text
.addPanel(
  pmmSinglestat.new(
    'CPU  Used',//title
    description='Show the CPU usage as a percentage for all Exporters on a per-host basis. An Exporter is a software library that provides metrics to PMM.\n\nSee also:',
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='5,10',
    colors=[
      "#299c46",
      "rgba(237, 129, 40, 0.89)",
      "#d44a3a",
    ],
    interval='',
    prefixFontSize='80%',
    postfixFontSize='80%',
    sparklineShow=true,
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        },
        {
          "dashUri": "db/prometheus-exporter-status",
          "dashboard": "Prometheus Exporter Status",
          "includeVars": true,
          "keepTime": true,
          "targetBlank": true,
          "title": "Prometheus Exporter Status",
          "type": "dashboard"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      '((sum(rate(process_cpu_seconds_total{job=~".*exporter.*",node_name=~"$host"}[$interval])) by (node_name)
      or sum(irate(process_cpu_seconds_total{job=~".*exporter.*",node_name=~"$host"}[5m])) by (node_name))
      / count(node_cpu_seconds_total{node_name=~"$host",mode="user"}) by (node_name)*100) or
      sum by () ((max_over_time(node_cpu_average{node_name=~"$host", mode="total"}[$interval]) or
      max_over_time(node_cpu_average{node_name=~"$host", mode="total"}[5m])))',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
    "h": 3,
      "w": 4,
      "x": 5,
      "y": 24,
  },
  style=null,
)//2228 pmm-singlestat
.addPanel(
  singlestat.new(
    'Mem Used',//title
    description='Shows total Memory Used by Exporters on a per-host basis. An Exporter is a software library that provides metrics to PMM.\n\nSee also:',
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    colorValue=true,
    thresholds='50000000,100000000',
    colors=[
        "rgba(50, 172, 45, 0.97)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(245, 54, 54, 0.9)",
    ],
    height='50',
    interval='$interval',
    valueFontSize='50%',
    valueMaps=[],
    sparklineShow=true,
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        },
        {
          "dashUri": "db/prometheus-exporter-status",
          "dashboard": "Prometheus Exporter Status",
          "includeVars": true,
          "keepTime": true,
          "targetBlank": true,
          "title": "Prometheus Exporter Status",
          "type": "dashboard"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'sum(process_resident_memory_bytes{job=~".*exporter.*",node_name=~"$host"}) by (node_name)',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      step=300,
      metric='node_mem',
    )
  ),
  gridPos = {
    "h": 3,
    "w": 4,
    "x": 9,
    "y": 24,
  },
  style=null,
)//163 singlestat
.addPanel(
  singlestat.new(
    'Exporters Running',//title
    description='Shows the number of Exporters running on a per-host basis. An Exporter is a software library that provides metrics to PMM.\n\nSee also:',
    format='short',
    datasource='Prometheus',
    valueName='current',
    decimals=0,
    colorValue=true,
    thresholds='512,800',
    colors=[
        "rgba(50, 172, 45, 0.97)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(245, 54, 54, 0.9)",
    ],
    height='50',
    interval='$interval',
    prefixFontSize='80%',
    valueMaps=[],
    sparklineShow=true,
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        },
        {
          "dashUri": "db/prometheus-exporter-status",
          "dashboard": "Prometheus Exporter Status",
          "includeVars": true,
          "keepTime": true,
          "targetBlank": true,
          "title": "Prometheus Exporter Status",
          "type": "dashboard"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'count(process_open_fds{job=~".*exporter.*",node_name=~"$host"}) ',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      step=300,
      metric='node_mem',
    )
  ),
  gridPos = {
    "h": 3,
    "w": 4,
    "x": 13,
    "y": 24,
  },
  style=null,
)//314 singlestat
.addPanel(
  tablePanel.new(
    title='',
    datasource='Prometheus',
    fontSize='100%',
    scroll=true,
    showHeader=true,
    sort={
      "col":2,
      "desc":true,
    },
  )
  .addStyle(
    {
          "alias": "Exporters",
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "pattern": "agent_type",
          "type": "string"
        }
  )
  .addStyle(
    {
        "alias": "Amount",
        "colorMode": null,
        "colors": [
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)"
        ],
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 0,
        "mappingType": 1,
        "pattern": "Value",
        "thresholds": [],
        "type": "number",
        "unit": "short"
      }
  )
  .addStyle(
      {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "decimals": 2,
          "pattern": "/.*/",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        }
  )
  .addTarget(
    prometheus.target(
      'count(process_cpu_seconds_total{node_name=~"$host"}) by (agent_type)',
      intervalFactor = 1,
      instant=true,
      format='table',
   )
   ),
  gridPos={
      "h": 6,
      "w": 7,
      "x": 17,
      "y": 24,
    },
    style=null,
)//2246 table
.addPanel(
  singlestat.new(
    'Virtual CPUs',//title
    description='Shows the total number of virtual CPUs on the host. An Exporter is a software library that provides metrics to PMM.\n\nSee also:',
    format='none',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colors=[
     "rgba(245, 54, 54, 0.9)",
     "rgba(237, 129, 40, 0.89)",
     "rgba(50, 172, 45, 0.97)",
    ],
    height='50',
    interval='$interval',
    prefixFontSize='80%',
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      '(count(node_cpu_seconds_total{node_name=~"$host",mode=~"user"}) or
      (1-absent(node_cpu_seconds_total{node_name=~"$host",mode=~"user"}))) + sum(rdsosmetrics_General_numVCPUs{node_name=~"$host"} or up * 0)',
      intervalFactor = 1,
      interval='$interval',
      step=300,
      instant=true,
    )
  ),
  gridPos = {
      "h": 3,
      "w": 4,
      "x": 5,
      "y": 27,
  },
  style=null,
)//25 singlestat
.addPanel(
  singlestat.new(
    'RAM',//title
    description='Shows the total amount of RAM of the host. An Exporter is a software library that provides metrics to PMM.\n\nSee also:',
    format='bytes',
    decimals=2,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colors=[
     "rgba(245, 54, 54, 0.9)",
     "rgba(237, 129, 40, 0.89)",
     "rgba(50, 172, 45, 0.97)",
    ],
    height='50',
    interval='$interval',
    postfixFontSize='30%',
    prefixFontSize='30%',
    valueFontSize='50%',
    links=[
        {
          "targetBlank": true,
          "title": "Understanding Prometheus Exporters",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2018/02/20/understand-prometheus-exporters-percona-monitoring-management-pmm/"
        },
        {
          "targetBlank": true,
          "title": "Exporters and integrations",
          "type": "absolute",
          "url": "https://prometheus.io/docs/instrumenting/exporters/"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'node_memory_MemTotal_bytes{node_name=~"$host"}',
      intervalFactor = 1,
      interval='$interval',
      step=300,
    )
  ),
  gridPos = {
      "h": 3,
      "w": 4,
      "x": 9,
      "y": 27,
  },
  style=null,
)//26 singlestat
.addPanel(
  singlestat.new(
    'File Descriptors Used',//title
    description='',
    format='short',
    datasource='Prometheus',
    valueName='current',
    thresholds='512,800',
    colorValue=true,
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)",
    ],
    height='50',
    interval='$interval',
    prefixFontSize='80%',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'sum(process_open_fds{node_name=~"$host"})',
      intervalFactor = 1,
      interval='$interval',
      step=300,
    )
  ),
  gridPos = {
      "h": 3,
      "w": 4,
      "x": 13,
      "y": 27,
  },
  style=null,
)//2263 singlestat
