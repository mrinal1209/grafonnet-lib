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


dashboard.new(
  'Trends Dashboard',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=1,
  tags=['Percona','Insight'],
  iteration=1555315940376,
  uid="wjZRrTiiz",
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
  tagValuesQuery='instance',
  tagsQuery='up',
  definition='label_values({__name__=~"node_load1|process_start_time_seconds"},node_name)',
  includeAll=false,
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
  definition='label_values({__name__=~"postgres_exporter_build_info|mysqld_exporter_build_info|mongodb_exporter_build_info|proxysql_exporter_build_info",node_name=~"$host"}, service_name)',
  includeAll=true,
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
)//39 row
.addPanel(
  graphPanel.new(
    'CPU Usage',//title
    description='Compares the percentage of CPU usage for the current selected range versus the previous day and the previous week for the same time range. This graph is useful to demonstrate how the CPU usage has changed over time by visually overlaying time periods.',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_hideEmpty=false,
    legend_hideZero=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='percent',
    formatY2='short',
  )
  .addTarget(
      prometheus.target(
        'avg by (node_name) ((sum by (mode) (
        (clamp_max(rate(node_cpu_seconds_total{node_name="$host",mode!="idle"}[$interval]),1)) or
        (clamp_max(irate(node_cpu_seconds_total{node_name="$host",mode!="idle"}[5m]),1)) ))*100
        or (sum by (mode) (
        clamp_max(((max_over_time(node_cpu_average{node_name="$host", mode!="idle"}[$interval]) or
        max_over_time(node_cpu_average{node_name="$host", mode!="idle"}[5m]))),100))))',
        refId='A',
        interval='$interval',
        calculatedInterval='2s',
        step=300,
        intervalFactor=1,
        legendFormat='Busy State',
        hide=false,
      )
  )
  .addTarget(
      prometheus.target(
        'avg by (node_name) ((sum by (mode) (
        (clamp_max(rate(node_cpu_seconds_total{node_name="$host",mode!="idle"}[$interval] offset 1d),1)) or
        (clamp_max(irate(node_cpu_seconds_total{node_name="$host",mode!="idle"}[5m] offset 1d),1)) ))*100
        or (sum by (mode) (
        clamp_max(((max_over_time(node_cpu_average{node_name="$host", mode!="idle"}[$interval] offset 1d) or
        max_over_time(node_cpu_average{node_name="$host", mode!="idle"}[5m] offset 1d))),100))))',
        refId='B',
        interval='$interval',
        calculatedInterval='2s',
        step=300,
        legendFormat='Busy State 1d ago',
        intervalFactor=1,
        hide=false,
      )
  )
  .addTarget(
      prometheus.target(
        'avg by (node_name) ((sum by (mode) (
        (clamp_max(rate(node_cpu_seconds_total{node_name="$host",mode!="idle"}[$interval] offset 1w),1)) or
        (clamp_max(irate(node_cpu_seconds_total{node_name="$host",mode!="idle"}[5m] offset 1w),1)) ))*100
        or (sum by (mode) (
        clamp_max(((max_over_time(node_cpu_average{node_name="$host", mode!="idle"}[$interval] offset 1w) or
        max_over_time(node_cpu_average{node_name="$host", mode!="idle"}[5m] offset 1w))),100))))',
        refId='C',
        interval='$interval',
        calculatedInterval='2s',
        step=300,
        legendFormat='Busy State 1w ago',
        intervalFactor=1,
        hide=false,
      )
  ),
  gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 1
  },
  style=null,
)//2 graph
.addPanel(
  graphPanel.new(
    'I/O Read Activity',//title
    description='Shows the comparison of I/O Read Activity in terms of bytes read for the current selected range versus the previous day and the previous week for the same time range. This graph is useful to demonstrate how I/O Read Activity has changed over time by visually overlaying time periods.',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_hideZero=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='Bps',
    formatY2='bytes',
  )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pgpgin{node_name="$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgin{node_name="$host"}[5m]) * 1024',
        refId='A',
        interval='$interval',
        calculatedInterval='2s',
        step=300,
        intervalFactor=1,
        legendFormat='Page In',
        hide=false,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pgpgin{node_name="$host"}[$interval] offset 1d) * 1024 or irate(node_vmstat_pgpgin{node_name="$host"}[5m] offset 1d) * 1024',
        refId='B',
        interval='$interval',
        calculatedInterval='2s',
        step=300,
        legendFormat='Page In 1d ago',
        intervalFactor=1,
        hide=false,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pgpgin{node_name="$host"}[$interval] offset 1w) * 1024 or irate(node_vmstat_pgpgin{node_name="$host"}[5m] offset 1w) * 1024',
        refId='C',
        interval='$interval',
        calculatedInterval='2s',
        step=300,
        legendFormat='Page In 1w ago',
        intervalFactor=1,
        hide=false,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 8,
    },
  style=null,
)//37 graph
.addPanel(
  graphPanel.new(
    'I/O Write Activity',//title
    description='Shows the comparison of I/O Write Activity in terms of bytes written for the current selected range versus the previous day and the previous week for the same time range. This graph is useful to demonstrate how I/O Write Activity has changed over time by visually overlaying time periods.',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_hideZero=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='Bps',
    formatY2='bytes',
  )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pgpgout{node_name="$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgout{node_name="$host"}[5m]) * 1024',
        refId='A',
        interval='$interval',
        calculatedInterval='2s',
        step=300,
        intervalFactor=1,
        legendFormat='Page Out',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pgpgout{node_name="$host"}[$interval] offset 1d) * 1024 or irate(node_vmstat_pgpgout{node_name="$host"}[5m] offset 1d) * 1024',
        refId='B',
        interval='$interval',
        calculatedInterval='2s',
        step=300,
        legendFormat='Page Out 1d ago',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pgpgout{node_name="$host"}[$interval] offset 1w) * 1024 or irate(node_vmstat_pgpgout{node_name="$host"}[5m] offset 1w) * 1024',
        refId='C',
        interval='$interval',
        calculatedInterval='2s',
        step=300,
        legendFormat='Page Out 1w ago',
        intervalFactor=1,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 8,
    },
  style=null,
)//38 graph
.addPanel(
    row.new(
      title='MySQL Stats',
    ),
    gridPos={
    "h": 1,
    "w": 24,
    "x": 0,
    "y": 15,
    },
    style=null,
)//40 row
.addPanel(
  graphPanel.new(
    'MySQL Questions',//title
    description='Shows the comparison of I/O Write Activity in terms of bytes written for the current selected range versus the previous day and the previous week for the same time range. This graph is useful to demonstrate how I/O Write Activity has changed over time by visually overlaying time periods.',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    format='short',
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_questions{service_name=~"$service"}[$interval]) or irate(mysql_global_status_questions{service_name=~"$service"}[5m])',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='Questions - {{service_name}}',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_questions{service_name=~"$service"}[$interval] offset 1d) or
        irate(mysql_global_status_questions{servoce_name=~"$service"}[5m] offset 1d)',
        refId='B',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        legendFormat='Questions 1d ago - {{service_name}}',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_questions{service_name=~"$service"}[$interval] offset 1w) or
        irate(mysql_global_status_questions{service_name=~"$service"}[5m] offset 1w)',
        refId='C',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        legendFormat='Questions 1w ago - {{service_name}}',
        intervalFactor=1,
      )
  ),
  gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 16,
    },
  style=null,
)//35 graph
.addPanel(
  graphPanel.new(
    'InnoDB Rows Read',//title
    description='Shows the comparison of the InnoDB Rows Read for the current selected range versus the previous day and the previous week for the same time range. This graph is useful to demonstrate how InnoDB Rows Read has changed over time by visually overlaying time periods.',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    format='short',
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_innodb_row_ops_total{service_name=~"$service", operation="read"}[$interval]) or
        irate(mysql_global_status_innodb_row_ops_total{service_name=~"$service", operation="read"}[5m])',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='Rows {{ operation }} - {{service_name}}',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_innodb_row_ops_total{service_name=~"$service", operation="read"}[$interval] offset 1d) or
        irate(mysql_global_status_innodb_row_ops_total{service_name=~"$service", operation="read"}[5m] offset 1d)',
        refId='B',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        legendFormat='Rows {{ operation }} 1d ago - {{service_name}}',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_innodb_row_ops_total{service_name=~"$service", operation="read"}[$interval] offset 1w) or
        irate(mysql_global_status_innodb_row_ops_total{service_name=~"$host", operation="read"}[5m] offset 1w)',
        refId='C',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        legendFormat='Rows {{ operation }} 1w ago - {{service_name}}',
        intervalFactor=1,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 23,
    },
  style=null,
)//34 graph
.addPanel(
  graphPanel.new(
    'InnoDB Rows Changed',//title
    description='Shows the comparison of innoDB Rows Changed for the current selected range versus the previous day and the previous week for the same time range. This graph is useful to demonstrate how the InnoDB Rows Changed has fluctuated over time by visually overlaying time periods.',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    format='short',
  )
  .addTarget(
      prometheus.target(
        'sum(rate(mysql_global_status_innodb_row_ops_total{service_name=~"$service", operation!="read"}[$interval])) by (service_name) or
        sum(irate(mysql_global_status_innodb_row_ops_total{servce_name=~"$service", operation!="read"}[5m])) by (service_name)',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='Rows inserted+updated+deleted - {{service_name}}',
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(mysql_global_status_innodb_row_ops_total{service_name=~"$service", operation!="read"}[$interval] offset 1d)) by (service_name) or
        sum(irate(mysql_global_status_innodb_row_ops_total{service_name=~"$service", operation!="read"}[5m] offset 1d)) by (service_name)',
        refId='B',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        legendFormat='Rows inserted+updated+deleted 1d ago - {{service_name}}',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(mysql_global_status_innodb_row_ops_total{service_name=~"$service_name", operation!="read"}[$interval] offset 1w)) by (service_name) or
        sum(irate(mysql_global_status_innodb_row_ops_total{service_name="$service_name", operation!="read"}[5m] offset 1w)) by (service_name)',
        refId='C',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        legendFormat='Rows inserted+updated+deleted 1w ago - {{service_name}}',
        intervalFactor=1,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 23,
    },
  style=null,
)//36 graph
