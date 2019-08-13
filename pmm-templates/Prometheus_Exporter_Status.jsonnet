local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local row = grafana.row;
local singlestat = grafana.singlestat;
local pmmSinglestat = grafana.pmmSinglestat;
local pmm = grafana.pmm;



dashboard.new(
  'Prometheus Exporter Status',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=5,
  tags=['Insight','Percona'],
  iteration=1555317238529,
  uid="o2zrwGNmz",
  timepicker = timepicker.new(
      collapse=false,
      hidden=false,
      now=true,
      enable=true,
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
  template.new(
  'host',
  'Prometheus',
  'label_values({__name__=~"node_load1|process_start_time_seconds"}, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='regex values',
  multi=false,
  skipUrlSync=false,
  definition='label_values({__name__=~"node_load1|process_start_time_seconds"}, node_name)',
  includeAll=false,
  tagsQuery='up',
  tagValuesQuery='instance',
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values({__name__=~"node_load1|process_start_time_seconds", node_name="$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=1,
  allFormat='glob',
  multi=true,
  multiFormat='regex values',
  skipUrlSync=false,
  definition='label_values({__name__=~"node_load1|process_start_time_seconds", node_name="$host"}, service_name)',
  includeAll=true,
  tagsQuery='up',
  tagValuesQuery='instance',
  ),
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
  pmm.new(
    ' ',
    'digiapulssi-breadcrumb-panel',
    isRootDashboard=false,
    transparent=true,
  )
  .addTarget(
  prometheus.target(
    '',
    intervalFactor=1,
    )
  ),
  gridPos={
        "h": 3,
        "w": 24,
        "x": 0,
        "y": 0
      },
  style=null
)//999 pmm
.addPanel(
    row.new(
      title='Node Exporter',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0,
    },
    style=null,
)//64 row
.addPanel(
  singlestat.new(
    'CPU Usage',//title
    format='percent',
    editable=true,
    decimals=1,
    datasource='Prometheus',
    valueName='current',
    thresholds='5,10',
    colorValue=true,
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)",
    ],
    sparklineShow=true,
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
    postfixFontSize='80%',
    valueFontSize='80%',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      '(sum(rate(process_cpu_seconds_total{node_name=~"$host",job=~"node_exporter_.*"}[$interval])) by () or
      sum(irate(process_cpu_seconds_total{node_name=~"$host",job=~"node_exporter_.*"}[5m])) by ()) /
      count(node_cpu_seconds_total{mode="user", node_name=~"$host"})*100',
      intervalFactor = 1,
      interval='$interval',
      step=300,
      calculatedInterval='10m',
    )
  ),
  gridPos = {
    "h": 4,
     "w": 6,
     "x": 0,
     "y": 1
  },
  style=null,
)//19 singlestat
.addPanel(
  singlestat.new(
    'Memory Usage',//title
    format='bytes',
    editable=true,
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='50000000,100000000',
    colorValue=true,
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)"
    ],
    interval="$interval",
    sparklineShow=true,
    height='125px',
    prefixFontSize='80%',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'process_resident_memory_bytes{node_name="$host",job=~"node_exporter_.*"}',
      intervalFactor = 1,
      interval='$interval',
      metric='node_mem',
      step=300,
      calculatedInterval='10m',
    )
  ),
  gridPos={
    "h": 4,
    "w": 6,
    "x": 6,
    "y": 1
  },
  style=null,
)//9 singlestat
.addPanel(
  singlestat.new(
    'File Descriptors Used',//title
    format='short',
    editable=true,
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='512,800',
    sparklineShow=true,
    colorValue=true,
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)"
    ],
    interval="$interval",
    height='125px',
    prefixFontSize='80%',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'process_open_fds{node_name="$host",job=~"node_exporter_.*"}',
      intervalFactor = 1,
      interval='$interval',
      metric='node_mem',
      step=300,
      calculatedInterval='10m',
    )
  ),
  gridPos={
    "h": 4,
    "w": 6,
    "x": 12,
    "y": 1
  },
  style=null,
)//36 singlestat
.addPanel(
  singlestat.new(
    'Exporter Uptime',//title
    format='s',
    editable=true,
    decimals=1,
    datasource='Prometheus',
    valueName='current',
    thresholds='300,3600',
    colorPostfix=true,
    colorValue=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
    ],
    interval="$interval",
    height='125px',
    prefixFontSize='80%',
    postfixFontSize='80%',
    postfix='s',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'time() - process_start_time_seconds{node_name="$host",job=~"node_exporter_.*"}',
      intervalFactor = 1,
      interval='$interval',
      step=300,
      calculatedInterval='10m',
    )
  ),
  gridPos={
    "h": 4,
    "w": 6,
    "x": 18,
    "y": 1
  },
  style=null,
)//35 singlestat
.addPanel(
  graphPanel.new(
    'Collector Scrape Successful',//title
    fill=0,
    linewidth=1,
    decimals=0,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    editable=true,
    format='none',
    maxY1='1',
    decimalsY1=0,
    min=0,
  )
  .addSeriesOverride({
          "alias": "Load 1m",
          "color": "#E0752D"
        })
  .addTarget(
      prometheus.target(
        'min_over_time(node_scrape_collector_success{node_name=~"$host"}[$interval]) or \nmin_over_time(node_scrape_collector_success{node_name=~"$host"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{collector}}',
        calculatedInterval='10s',
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 0,
    "y": 5
  },style=null
)//18 graph
.addPanel(
  graphPanel.new(
    'Collector Execution Time  (Log Scale)',//title
    fill=0,
    linewidth=1,
    decimals=null,
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
    formatY1='s',
    formatY2='none',
    logBase1Y=2,
    minY2=0,
  )
  .addSeriesOverride({
          "alias": "Total Load",
          "color": "#C4162A",
          "linewidth": 2
        })
  .addTarget(
      prometheus.target(
        'avg_over_time(node_scrape_collector_duration_seconds{node_name="$host"}[$interval]) or \navg_over_time(node_scrape_collector_duration_seconds{node_name="$host"}[5m])',
        interval='$interval',
        step=300,
        intervalFactor=1,
        legendFormat='{{collector}}',
        calculatedInterval='10s',
      )
  )
  .addTarget(
      prometheus.target(
        'sum(avg_over_time(node_scrape_collector_duration_seconds{node_name="$host"}[$interval])) or \nsum(avg_over_time(node_scrape_collector_duration_seconds{node_name="$host"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Total Load',
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 12,
    "y": 5
  },style=null
)//37 graph
.addPanel(
    row.new(
      title='MySQL Exporter $service',
      collapse=true,
    )
    .addPanel(
      pmmSinglestat.new(
        'CPU Usage',//title
        format='percent',
        decimals=null,
        datasource='Prometheus',
        valueName='current',
        thresholds='5,10',
        colorValue=true,
        colors=[
          "#299c46",
         "rgba(237, 129, 40, 0.89)",
         "#d44a3a",
        ],
        sparklineShow=true,
        interval=null,
        height='125px',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          '(sum(rate(process_cpu_seconds_total{node_name="$host",service_name=~"$service",job=~"mysqld_exporter.*"}[$interval])) by () or
          sum(irate(process_cpu_seconds_total{node_name="$host",service_name=~"$service",job=~"mysqld_exporter.*"}[5m])) by ()) /
          count(node_cpu_seconds_total{mode="user",node_name="$host"})*100',
          intervalFactor = 1,
          interval='$interval',
        )
      ),
      gridPos={
            "h": 4,
              "w": 6,
              "x": 0,
              "y": 14
      }
    )//62 pmm-singlestat
    .addPanel(
      singlestat.new(
        'Memory Usage',//title
        format='bytes',
        editable=true,
        decimals=0,
        datasource='Prometheus',
        valueName='current',
        thresholds='50000000,100000000',
        colorValue=true,
        colors=[
            "#299c46",
            "rgba(237, 129, 40, 0.89)",
            "#d44a3a"
        ],
        sparklineShow=true,
        interval=null,
        height='125px',
        prefixFontSize='80%',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'sum(process_resident_memory_bytes{node_name="$host",service_name=~"$service",job=~"mysqld_exporter.*"})',
          intervalFactor = 1,
          interval='$interval',
        )
      ),
      gridPos={
          "h": 4,
          "w": 6,
          "x": 6,
          "y": 14
      }
    )//61 singlestat
    .addPanel(
      singlestat.new(
        'File Descriptors Used',//title
        format='short',
        editable=true,
        decimals=0,
        datasource='Prometheus',
        valueName='current',
        thresholds='512,800',
        colorValue=true,
        colors=[
            "#299c46",
            "rgba(237, 129, 40, 0.89)",
            "#d44a3a"
        ],
        interval=null,
        sparklineShow=true,
        height='125px',
        prefixFontSize='80%',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'sum(process_open_fds{node_name="$host",service_name=~"$service",job=~"mysqld_exporter.*"})',
          intervalFactor = 1,
          interval='$interval',
        )
      ),
      gridPos={
          "h": 4,
          "w": 6,
          "x": 12,
          "y": 14
      }
    )//60 singlestat
    .addPanel(
      singlestat.new(
        'Exporter Uptime',//title
        format='s',
        editable=true,
        decimals=1,
        datasource='Prometheus',
        valueName='current',
        thresholds='300,3600',
        colorPostfix=true,
        colorValue=true,
        colors=[
          "#d44a3a",
          "rgba(237, 129, 40, 0.89)",
          "#299c46"
        ],
        interval=null,
        sparklineShow=true,
        height='125px',
        prefixFontSize='80%',
        postfixFontSize='80%',
        postfix='s',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'time() - avg(process_start_time_seconds{node_name="$host",service_name=~"$service",job=~"mysqld_exporter.*"})',
          intervalFactor = 1,
          interval='$interval',
        )
      ),
      gridPos={
          "h": 4,
          "w": 6,
          "x": 18,
          "y": 14
      }
    )//59 singlestat
    .addPanel(
      graphPanel.new(
        'Collector Execution Time',//title
        fill=0,
        linewidth=1,
        decimals=null,
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
        formatY1='s',
        formatY2='none',
        min=0,
      )
      .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#E0752D"
            })
      .addTarget(
          prometheus.target(
            "avg_over_time(mysql_exporter_collector_duration_seconds{node_name=\"$host\",service_name=~\"$service\"}[$interval]) or \navg_over_time(mysql_exporter_collector_duration_seconds{node_name=\"$host\",service_name=~\"$service\"}[5m])",
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='{{collector}} - {{service_name}}',
            calculatedInterval='10s',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 18
      }
    )//37 graph
    .addPanel(
      graphPanel.new(
        'MySQL Exporter Errors',//title
        fill=0,
        linewidth=1,
        decimals=null,
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
        formatY1='short',
        formatY2='none',
        min=0,
        aliasColors={
            "High Resolution": "#58140c",
            "Low Resolution": "#e24d42",
            "Medium Resolution": "#bf1b00"
          },
      )
      .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#E0752D"
            })
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_exporter_hr_last_scrape_error{node_name="$host",service_name=~"$service"}[$interval]) or \nmax_over_time(mysql_exporter_hr_last_scrape_error{node_name="$host",service_name=~"$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='High Resolution - {{service_name}}',
            calculatedInterval='10s',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_exporter_mr_last_scrape_error{node_name="$host",service_name=~"$service"}[$interval]) or \nmax_over_time(mysql_exporter_mr_last_scrape_error{node_name="$host",service_name=~"$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Medium Resolution {{service_name}}',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_exporter_lr_last_scrape_error{node_name="$host",service_name=~"$service"}[$interval]) or \nmax_over_time(mysql_exporter_lr_last_scrape_error{node_name="$host",service_name=~"$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Low Resolution - {{service_name}}',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 18
      }
    )//38 graph
    .addPanel(
      graphPanel.new(
        'Rate of  Scrapes',//title
        fill=0,
        linewidth=1,
        decimals=null,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        editable=true,
        formatY1='ops',
        formatY2='none',
        min=0,
        aliasColors={
            "High Resolution": "#64b0c8",
            "Low Resolution": "#705da0",
            "Medium Resolution": "#1f78c1"
          },
      )
      .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#E0752D"
            })
      .addTarget(
          prometheus.target(
            'rate(mysql_exporter_hr_scrapes_total{node_name="$host",service_name=~"$service"}[$interval]) or \nirate(mysql_exporter_hr_scrapes_total{node_name="$host",service_name=~"$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='High Resolution - {{service_name}}',
            calculatedInterval='10s',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_exporter_mr_scrapes_total{node_name="$host",service_name=~"$service"}[$interval]) or \nirate(mysql_exporter_mr_scrapes_total{node_name="$host",service_name=~"$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Medium Resolution - {{service_name}}',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_exporter_lr_scrapes_total{node_name="$host",service_name=~"$service"}[$interval]) or \nirate(mysql_exporter_lr_scrapes_total{node_name="$host",service_name=~"$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Low Resolution - {{service_name}}',
          )
      ),
      gridPos={
            "h": 7,
            "w": 12,
            "x": 0,
            "y": 25
      }
    )//39 graph
    .addPanel(
      graphPanel.new(
        'MySQL up',//title
        fill=0,
        linewidth=1,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        editable=true,
        formatY1='short',
        formatY2='none',
        min=0,
        aliasColors={
            "High Resolution": "#64b0c8",
            "Low Resolution": "#705da0",
            "Medium Resolution": "#1f78c1"
          },
      )
      .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#E0752D"
            })
      .addTarget(
          prometheus.target(
            'min_over_time(mysql_up{node_name="$host",service_name=~"$service",job=~"mysqld_exporter_.*_hr"}[$interval]) or \nmin_over_time(mysql_up{node_name="$host",service_name=~"$service",job=~"mysqld_exporter_.*_hr"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='MySQL Up - {{service_name}}',
            calculatedInterval='10s',
          )
      ),
      gridPos={
            "h": 7,
            "w": 12,
            "x": 12,
            "y": 25
      }
    )//40 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 13,
    },
    style=null,
)//65 row
.addPanel(
    row.new(
      title='MongoDB Exporter',
      collapse=true,
    )
    .addPanel(
      pmmSinglestat.new(
        'CPU Usage',//title
        format='percent',
        decimals=1,
        datasource='Prometheus',
        valueName='current',
        thresholds='5,10',
        colorValue=true,
        colors=[
          "rgba(50, 172, 45, 0.97)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(245, 54, 54, 0.9)"
        ],
        sparklineShow=true,
        interval='$interval',
        height='125px',
        valueMaps=[],
        prefixFontSize='80%',
        postfixFontSize='80%',
      )
      .addTarget(
        prometheus.target(
          '(sum(rate(process_cpu_seconds_total{node_name="$host",service_name=~"$service",job=~"mongodb.*"}[$interval])) by () or
          sum(irate(process_cpu_seconds_total{node_name="$host",service_name=~"$service",job=~"mongodb.*"}[5m])) by ()) /
          count(node_cpu_seconds_total{mode="user",node_name="$host"})*100',
          intervalFactor = 1,
          interval='$interval',
          calculatedInterval='10m',
          step=300,
        )
      ),
      gridPos={
            "h": 4,
              "w": 6,
              "x": 0,
              "y": 33
      }
    )//42 pmm-singlestat
    .addPanel(
      singlestat.new(
        'Memory Usage',//title
        format='bytes',
        editable=true,
        decimals=0,
        datasource='Prometheus',
        valueName='current',
        thresholds='50000000,100000000',
        colorValue=true,
        colors=[
          "rgba(50, 172, 45, 0.97)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(245, 54, 54, 0.9)",
        ],
        sparklineShow=true,
        interval='$interval',
        height='125px',
        prefixFontSize='80%',
        valueFontSize='80%',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'sum(process_resident_memory_bytes{node_name="$host",service_name=~"$service",job=~"mongodb.*"})',
          intervalFactor = 1,
          interval='$interval',
          step=300,
          calculatedInterval='10m',
          metric='node_mem',
        )
      ),
      gridPos = {
        "h": 4,
         "w": 6,
         "x": 6,
          "y": 33
      }
    )//43 singlestat
    .addPanel(
      singlestat.new(
        'File Descriptors Used',//title
        format='short',
        editable=true,
        decimals=0,
        datasource='Prometheus',
        valueName='current',
        thresholds='512,800',
        colorValue=true,
        colors=[
          "rgba(50, 172, 45, 0.97)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(245, 54, 54, 0.9)",
        ],
        sparklineShow=true,
        interval='$interval',
        height='125px',
        prefixFontSize='80%',
        valueFontSize='80%',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'sum(process_open_fds{node_name="$host",service_name="~$service",job=~"mongodb.*"})',
          intervalFactor = 1,
          interval='$interval',
          step=300,
          calculatedInterval='10m',
          metric='node_mem',
        )
      ),
      gridPos = {
          "h": 4,
          "w": 6,
          "x": 12,
          "y": 33
      }
    )//44 singlestat
    .addPanel(
      singlestat.new(
        'Exporter Uptime',//title
        format='s',
        editable=true,
        decimals=1,
        datasource='Prometheus',
        valueName='current',
        thresholds='300,3600',
        colorPostfix=true,
        colorValue=true,
        colors=[
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)",
        ],
        interval='$interval',
        height='125px',
        prefixFontSize='80%',
        postfixFontSize='80%',
        postfix='s',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'time() - avg(process_start_time_seconds{node_name="$host",service_name=~"$service",job=~"mongodb.*"})',
          intervalFactor = 1,
          interval='$interval',
          step=300,
          calculatedInterval='10m',
        )
      ),
      gridPos = {
          "h": 4,
          "w": 6,
          "x": 18,
          "y": 33
      }
    )//45 singlestat
    .addPanel(
      graphPanel.new(
        'MongoDB Scrape Performance',//title
        fill=0,
        linewidth=1,
        decimals=null,
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
        formatY1='s',
        formatY2='none',
        min=0,
      )
      .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#E0752D"
            })
      .addTarget(
          prometheus.target(
            'avg_over_time(mongodb_exporter_last_scrape_duration_seconds{node_name="$host",service_name=~"$service",job=~"mongodb.*"}[$interval]) or\navg_over_time(mongodb_exporter_last_scrape_duration_seconds{node_name="$host",service_name=~"$service",job=~"mongodb.*"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Avg Scrape Time - {{service_name}}',
            calculatedInterval='10s',
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 0,
         "y": 37
      }
    )//46 graph
    .addPanel(
      graphPanel.new(
        'MongoDB Exporter Errors',//title
        fill=0,
        linewidth=1,
        decimals=null,
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
        formatY1='short',
        formatY2='none',
        min=0,
        aliasColors={
            "High Resolution": "#58140c",
            "Low Resolution": "#e24d42",
            "Medium Resolution": "#bf1b00",
            "MongoDB Exporter Errors": "#bf1b00"
          },
      )
      .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#E0752D"
            })
      .addTarget(
          prometheus.target(
            'max_over_time(mongodb_exporter_last_scrape_error{node_name="$host",service_name=~"$service",job=~"mongodb.*"}[$interval]) or \nmax_over_time(mongodb_exporter_last_scrape_error{node_name="$host",service_name=~"$service",job=~"mongodb.*"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='MongoDB Exporter Errors  - {{service_name}}',
            calculatedInterval='10s',
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 12,
         "y": 37
      }
    )//47 graph
    .addPanel(
      graphPanel.new(
        'Rate of  Scrapes',//title
        fill=0,
        linewidth=1,
        decimals=null,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        editable=true,
        formatY1='ops',
        formatY2='none',
        min=0,
        aliasColors={
            "High Resolution": "#64b0c8",
            "Low Resolution": "#705da0",
            "Medium Resolution": "#1f78c1"
          },
      )
      .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#E0752D"
            })
      .addTarget(
          prometheus.target(
            'rate(mongodb_exporter_scrapes_total{node_name="$host",service_name=~"$service",job=~"mongodb.*"}[$interval]) or \nirate(mongodb_exporter_scrapes_total{node_name="$host",service_name=~"$service",job=~"mongodb.*"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Scrapes Rate  - {{service_name}}',
            calculatedInterval='10s',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 45
      }
    )//48 graph
    .addPanel(
      graphPanel.new(
        'MongoDB up',//title
        fill=0,
        linewidth=1,
        decimals=2,
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
        minY1='0',
      )
      .addTarget(
          prometheus.target(
            'min_over_time(mongodb_up{node_name="$host",service_name="$service",job=~"mongodb.*"}[$interval]) or \nmin_over_time(mongodb_up{node_name="$host",service_name="$service",job=~"mongodb.*"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='MongoDB Up',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 45
      }
    )//63 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 14,
    },
    style=null,
)//66 row
.addPanel(
    row.new(
      title='ProxySQL Exporter',
      collapse=true,
    )
    .addPanel(
      pmmSinglestat.new(
        'CPU Usage',//title
        format='percent',
        decimals=1,
        datasource='Prometheus',
        valueName='current',
        thresholds='5,10',
        colorValue=true,
        colors=[
          "rgba(50, 172, 45, 0.97)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(245, 54, 54, 0.9)"
        ],
        sparklineShow=true,
        interval='$interval',
        height='125px',
        valueMaps=[],
        prefixFontSize='80%',
        postfixFontSize='80%',
      )
      .addTarget(
        prometheus.target(
          '(sum(rate(process_cpu_seconds_total{node_name="$host",service_name=~"$service",job=~"proxysql.*"}[$interval])) by () or
          sum(irate(process_cpu_seconds_total{node_name="$host",service_name=~"$service",job=~"proxysql.*"}[5m])) by ()) /
          count(node_cpu_seconds_total{mode="user",node_name="$host"})*100',
          intervalFactor = 1,
          interval='$interval',
          calculatedInterval='10m',
          step=300,
        )
      ),
      gridPos={
              "h": 4,
              "w": 6,
              "x": 0,
              "y": 34
      }
    )//41 pmm-singlestat
    .addPanel(
      singlestat.new(
        'Memory Usage',//title
        format='bytes',
        editable=true,
        decimals=0,
        datasource='Prometheus',
        valueName='current',
        thresholds='50000000,100000000',
        colorValue=true,
        colors=[
          "rgba(50, 172, 45, 0.97)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(245, 54, 54, 0.9)",
        ],
        sparklineShow=true,
        interval='$interval',
        height='125px',
        prefixFontSize='80%',
        valueFontSize='80%',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'sum(process_resident_memory_bytes{node_name="$host",service_name=~"$service",job=~"proxysql.*"})',
          intervalFactor = 1,
          interval='$interval',
          step=300,
          calculatedInterval='10m',
          metric='node_mem',
        )
      ),
      gridPos = {
        "h": 4,
         "w": 6,
         "x": 6,
          "y": 34
      }
    )//49 singlestat
    .addPanel(
      singlestat.new(
        'File Descriptors Used',//title
        format='short',
        editable=true,
        decimals=0,
        datasource='Prometheus',
        valueName='current',
        thresholds='512,800',
        colorValue=true,
        colors=[
          "rgba(50, 172, 45, 0.97)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(245, 54, 54, 0.9)",
        ],
        sparklineShow=true,
        interval='$interval',
        height='125px',
        prefixFontSize='80%',
        valueFontSize='80%',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'sum(process_open_fds{node_name="$host",service_name=~"$service",job=~"proxysql.*"})',
          intervalFactor = 1,
          interval='$interval',
          step=300,
          calculatedInterval='10m',
          metric='node_mem',
        )
      ),
      gridPos = {
          "h": 4,
          "w": 6,
          "x": 12,
          "y": 34
      }
    )//50 singlestat
    .addPanel(
      singlestat.new(
        'Exporter Uptime',//title
        format='s',
        editable=true,
        decimals=1,
        datasource='Prometheus',
        valueName='current',
        thresholds='300,3600',
        colorPostfix=true,
        colorValue=true,
        colors=[
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)",
        ],
        interval='$interval',
        height='125px',
        prefixFontSize='80%',
        postfixFontSize='80%',
        postfix='s',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'time() - avg(process_start_time_seconds{node_name="$host",service_name=~"$service",job=~"proxysql.*"})',
          intervalFactor = 1,
          interval='$interval',
          step=300,
          calculatedInterval='10m',
        )
      ),
      gridPos = {
          "h": 4,
          "w": 6,
          "x": 18,
          "y": 34
      }
    )//51 singlestat
    .addPanel(
      graphPanel.new(
        'ProxySQL Scrape Performance',//title
        fill=0,
        linewidth=1,
        decimals=null,
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
        formatY1='s',
        formatY2='none',
        min=0,
      )
      .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#E0752D"
            })
      .addTarget(
          prometheus.target(
            'avg_over_time(proxysql_exporter_last_scrape_duration_seconds{node_name="$host",service_name=~"$service",job=~"proxysql.*"}[$interval]) or \navg_over_time(proxysql_exporter_last_scrape_duration_seconds{node_name="$host",service_name=~"$service",job=~"proxysql.*"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Avg Scrape Time - {{service_name}}',
            calculatedInterval='10s',
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 0,
         "y": 38
      }
    )//52 graph
    .addPanel(
      graphPanel.new(
        'ProxySQL Exporter Errors',//title
        fill=0,
        linewidth=1,
        decimals=null,
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
        formatY1='short',
        formatY2='none',
        min=0,
        aliasColors={
            "High Resolution": "#58140c",
            "Low Resolution": "#e24d42",
            "Medium Resolution": "#bf1b00",
            "MongoDB Exporter Errors": "#bf1b00",
            "ProxySQL Exporter Errors": "#bf1b00"
          },
      )
      .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#E0752D"
            })
      .addTarget(
          prometheus.target(
            'max_over_time(proxysql_exporter_last_scrape_error{node_name="$host",service_name=~"$service",job=~"proxysql.*"}[$interval]) or \nmax_over_time(proxysql_exporter_last_scrape_error{node_name="$host",service_name=~"$service",job=~"proxysql.*"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='ProxySQL Exporter Errors  - {{service_name}}',
            calculatedInterval='10s',
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 12,
         "y": 38
      }
    )//53 graph
    .addPanel(
      graphPanel.new(
        'Rate of  Scrapes',//title
        fill=0,
        linewidth=1,
        decimals=null,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        editable=true,
        formatY1='ops',
        formatY2='none',
        min=0,
        aliasColors={
            "High Resolution": "#64b0c8",
            "Low Resolution": "#705da0",
            "Medium Resolution": "#1f78c1",
            "Scrapes Rate": "#1f78c1",
          },
      )
      .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#E0752D"
            })
      .addTarget(
          prometheus.target(
            'rate(proxysql_exporter_scrapes_total{node_name="$host",service_name=~"$service",job=~"proxysql.*"}[$interval]) or \nirate(proxysql_exporter_scrapes_total{node_name="$host",service_name=~"$service",job=~"proxysql.*"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Scrapes Rate  - {{service_name}}',
            calculatedInterval='10s',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 46
      }
    )//54 graph
    .addPanel(
      graphPanel.new(
        'ProxySQL up',//title
        fill=0,
        linewidth=1,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        editable=true,
        min=0,
        formatY2='none',
        aliasColors={
            "High Resolution": "#64b0c8",
            "Low Resolution": "#705da0",
            "Medium Resolution": "#1f78c1"
          },
      )
      .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#E0752D"
            })
      .addTarget(
          prometheus.target(
            'min_over_time(proxysql_up{node_name="$host",service_name=~"$service",job=~"proxysql.*"}[$interval]) or \nmin_over_time(proxysql_up{node_name="$host",service_name=~"$service",job=~"proxysql.*"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='ProxySQL Up  - {{service_name}}',
            calculatedInterval='10s',
            step=300,
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 46
      }
    )//55 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 15,
    },
    style=null,
)//67 row
.addPanel(
    row.new(
      title='PostgreSQL Exporter',
      collapse=true,
    )
    .addPanel(
      singlestat.new(
        'CPU Usage',//title
        format='percent',
        decimals=1,
        datasource='Prometheus',
        valueName='current',
        thresholds='5,10',
        colorValue=true,
        colors=[
          "rgba(50, 172, 45, 0.97)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(245, 54, 54, 0.9)"
        ],
        sparklineShow=true,
        interval='$interval',
        height='125px',
        valueMaps=[],
        prefixFontSize='80%',
        postfixFontSize='80%',
      )
      .addTarget(
        prometheus.target(
          '(sum(rate(process_cpu_seconds_total{node_name="$host",service_name=~"$service",job=~"postgres.*"}[$interval])) by () or
          sum(irate(process_cpu_seconds_total{node_name="$host",service_name=~"$service",job=~"postgres.*"}[5m])) by ()) /
          count(node_cpu_seconds_total{mode="user",node_name="$host"})*100',
          intervalFactor = 1,
          interval='$interval',
          calculatedInterval='10m',
          step=300,
        )
      ),
      gridPos={
              "h": 4,
              "w": 6,
              "x": 0,
              "y": 35
      }
    )//70 singlestat
    .addPanel(
      singlestat.new(
        'Memory Usage',//title
        format='bytes',
        editable=true,
        decimals=0,
        datasource='Prometheus',
        valueName='current',
        thresholds='50000000,100000000',
        colorValue=true,
        colors=[
          "rgba(50, 172, 45, 0.97)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(245, 54, 54, 0.9)",
        ],
        sparklineShow=true,
        interval='$interval',
        height='125px',
        prefixFontSize='80%',
        valueFontSize='80%',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'sum(process_resident_memory_bytes{node_name="$host",service_name=~"$service",job=~"postgres.*"})',
          intervalFactor = 1,
          interval='$interval',
          step=300,
          calculatedInterval='10m',
          metric='node_mem',
        )
      ),
      gridPos={
        "h": 4,
         "w": 6,
         "x": 6,
          "y": 35
      }
    )//71 singlestat
    .addPanel(
      singlestat.new(
        'File Descriptors Used',//title
        format='short',
        editable=true,
        decimals=0,
        datasource='Prometheus',
        valueName='current',
        thresholds='512,800',
        colorValue=true,
        colors=[
          "rgba(50, 172, 45, 0.97)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(245, 54, 54, 0.9)",
        ],
        sparklineShow=true,
        interval='$interval',
        height='125px',
        prefixFontSize='80%',
        valueFontSize='80%',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'sum(process_open_fds{node_name="$host",service_name=~"$service",job=~"postgres.*"})',
          intervalFactor = 1,
          interval='$interval',
          step=300,
          calculatedInterval='10m',
          metric='node_mem',
        )
      ),
      gridPos = {
          "h": 4,
          "w": 6,
          "x": 12,
          "y": 35
      }
    )//72 singlestat
    .addPanel(
      singlestat.new(
        'Exporter Uptime',//title
        format='s',
        editable=true,
        decimals=1,
        datasource='Prometheus',
        valueName='current',
        thresholds='300,3600',
        colorPostfix=true,
        colorValue=true,
        colors=[
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)",
        ],
        interval='$interval',
        height='125px',
        prefixFontSize='80%',
        postfixFontSize='80%',
        postfix='s',
        valueMaps=[],
      )
      .addTarget(
        prometheus.target(
          'time() - avg(process_start_time_seconds{node_name="$host",service_name=~"$service",job=~"postgres.*"})',
          intervalFactor = 1,
          interval='$interval',
          step=300,
          calculatedInterval='10m',
        )
      ),
      gridPos = {
          "h": 4,
          "w": 6,
          "x": 18,
          "y": 35
      }
    )//73 singlestat
    .addPanel(
      graphPanel.new(
        'Rate of  Scrapes',//title
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        editable=true,
        formatY1='ops',
        formatY2='none',
        min=0,
      )
      .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#E0752D"
            })
      .addTarget(
          prometheus.target(
            'rate(pg_exporter_scrapes_total{node_name="$host",service_name=~"$service",job=~"postgres.*"}[$interval]) or \nirate(pg_exporter_scrapes_total{node_name="$host",service_name=~"$service",job=~"postgres.*"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Total  - {{service_name}}',
            calculatedInterval='10s',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(pg_exporter_last_scrape_error{node_name="$host",service_name=~"$service",job=~"postgres.*"}[$interval]) or\nmax_over_time(pg_exporter_last_scrape_error{node_name="$host",service_name=~"$service",job=~"postgres.*"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Failed  - {{service_name}}',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 39
      }
    )//74 graph
    .addPanel(
      graphPanel.new(
        'Scrape Durations',//title
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=false,
        legend_min=false,
        legend_max=false,
        legend_avg=false,
        legend_show=true,
        editable=true,
        minY1='0',
        formatY1='s',
      )
      .addTarget(
          prometheus.target(
            'sum_over_time(pg_exporter_last_scrape_duration_seconds{node_name="$host",service_name=~"$service",job=~"postgres.*"}[$interval]) or\nsum_over_time(pg_exporter_last_scrape_duration_seconds{node_name="$host",service_name=~"$service",job=~"postgres.*"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Duration  - {{service_name}}',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 39
      }
    )//76 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 16,
    },
    style=null,
)//69 row
