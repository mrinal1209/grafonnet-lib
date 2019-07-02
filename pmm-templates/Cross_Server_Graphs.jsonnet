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
  'Cross Server Graphs',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=1,
  tags=[
    "Percona",
    "Insight"],
  iteration=1555316081225,
  uid="Swz9QGNmz",
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
  'label_values({__name__=~"node_load1|mysql_up"}, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='pipe',
  multiFormat='pipe',
  multi=true,
  skipUrlSync=false,
  definition='label_values({__name__=~"node_load1|mysql_up"}, node_name)',
  includeAll=true,
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values({__name__=~"postgres_exporter_build_info|mysqld_exporter_build_info|mongodb_exporter_build_info|proxysql_exporter_build_info",node_name=~"$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=1,
  multi=true,
  skipUrlSync=false,
  definition='label_values({__name__=~"postgres_exporter_build_info|mysqld_exporter_build_info|mongodb_exporter_build_info|proxysql_exporter_build_info",node_name=~"$host"}, service_name)',
  includeAll=true,
  ),
)
.addPanel(
  graphPanel.new(
    'Load Average',//title
    description="**Load Average**

    On Linux, this is the number of processes which are in 'running' state or in 'uninterruptible sleep' state which typically corresponds to disk IO. You can also map LoadAvg to VMSTAT output – it is something like moving average of sum of 'r' and 'b' columns from VMSTAT.

    This chart is best used for trends. If you notice the load average rising, it may be due to innefficient queries. In that case, it is a good idea to look at PMM's Query Analytics.",
    fill=2,
    linewidth=2,
    decimals=2,
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
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    format='none',
    min=0,
    links=[
        {
           "dashUri": "db/_pmm-query-analytics",
           "dashboard": "_PMM Query Analytics",
           "title": "PMM Query Analytics",
           "type": "dashboard",
           "url": "/graph/d/7w6Q3PJmz/pmm-query-analytics"
        },
        {
         "dashboard": "https://www.percona.com/blog/2006/12/04/using-loadavg-for-performance-optimization/",
         "title": "Using LoadAvg for Performance Optimization",
         "type": "absolute",
         "url": "https://www.percona.com/blog/2006/12/04/using-loadavg-for-performance-optimization/"
        }
        ],
    thresholds=[
                  {
                      "colorMode": "custom",
                      "line": true,
                      "lineColor": "rgb(241, 34, 15)",
                      "op": "gt",
                      "value": 15,
                      "yaxis": "left"
                  }
              ],
  )
  .addTarget(
      prometheus.target(
        'node_load1{node_name=~"$host"}',
        refId='A',
        interval='$interval',
        calculatedInterval='10s',
        step=300,
        intervalFactor=1,
        legendFormat='{{ node_name }}',
      )
   ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 0,
        },
  style=null,
)//6 graph
.addPanel(
  graphPanel.new(
    'Memory Usage',//title
    fill=2,
    linewidth=2,
    decimals=2,
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
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    formatY2='none',
    formatY1='percent',
    min=0,
    thresholds=[
              {
                  "colorMode": "custom",
                  "line": true,
                  "lineColor": "rgb(248, 8, 48)",
                  "op": "gt",
                  "value": 95,
                  "yaxis": "left"
              }
          ],
  )
  .addTarget(
      prometheus.target(
        '100 - 100 * (node_memory_MemAvailable_bytes{node_name=~"$host"} or (node_memory_MemFree_bytes{node_name=~"$host"} +
        node_memory_Buffers_bytes{node_name=~"$host"} + node_memory_Cached_bytes{node_name=~"$host"})) / (node_memory_MemTotal_bytes{node_name=~"$host"} + 0.1)',
        refId='A',
        interval='$interval',
        calculatedInterval='10s',
        step=300,
        intervalFactor=1,
        legendFormat='{{ node_name }}',
      )
   ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 0,
        },
  style=null,
)//7 graph
.addPanel(
  graphPanel.new(
    'MySQL Connections',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    format='short',
    min=0,
    value_type='cumulative',
  )
  .addTarget(
      prometheus.target(
        'sum(rate(mysql_global_status_connections{service_name=~"$service"}[$interval])) by (service_name) or
        sum(irate(mysql_global_status_connections{service_name=~"$service"}[5m])) by (service_name)',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ service_name }}',
      )
   ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 7,
        },
  style=null,
)//3 graph
.addPanel(
  graphPanel.new(
    'MySQL Queries',//title
    description="**MySQL Queries**

    Based on the queries reported by MySQL's ''SHOW STATUS'' command, it is the average number of statements executed by the server. This variable includes statements executed within stored programs, unlike the Questions variable. It does not count COM_PING or COM_STATISTICS commands.",
    fill=2,
    linewidth=2,
    decimals=2,
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
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    format='short',
    min=0,
    value_type='cumulative',
    links=[
        {
          "title": "Server Status Variables (Queries)",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.6/en/server-status-variables.html#statvar_Queries"
        }
      ],
  )
  .addTarget(
      prometheus.target(
        'sum(rate(mysql_global_status_queries{service_name=~"$service"}[$interval])) by (service_name) or
        sum(irate(mysql_global_status_queries{service_name=~"$service"}[5m])) by (service_name)',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ service_name }}',
      )
   ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 7,
        },
  style=null,
)//4 graph
.addPanel(
  graphPanel.new(
    'MySQL Traffic',//title
    description='**MySQL Traffic**

    Network traffic used by the MySQL process.',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    formatY1='Bps',
    formatY2='none',
    min=0,
  )
  .addTarget(
      prometheus.target(
        'sum((rate(mysql_global_status_bytes_received{service_name=~"$service"}[$interval]) +
        rate(mysql_global_status_bytes_sent{service_name=~"$service"}[$interval]))) by (service_name) or
        sum((irate(mysql_global_status_bytes_received{service_name=~"$service"}[5m]) +
        irate(mysql_global_status_bytes_sent{service_name=~"$service"}[5m]))) by (service_name)',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ service_name }}',
      )
   ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 14,
        },
  style=null,
)//11 graph
.addPanel(
  graphPanel.new(
    'Network Traffic',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_hideEmpty=false,
    legend_rightSide=false,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    formatY1='Bps',
    formatY2='bytes',
    min=0,
  )
  .addTarget(
      prometheus.target(
        'sum(rate(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[$interval]) +
        rate(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[$interval])) by (node_name) or
        sum(irate(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[5m]) +
        irate(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[5m])) by (node_name) or
        sum(max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[$interval]) +
        max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[$interval])) by (node_name) or
        sum(max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[5m]) +
        max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[5m])) by (node_name)',
        refId='B',
        interval='$interval',
        calculatedInterval='2s',
        step=300,
        intervalFactor=1,
        legendFormat='{{ node_name }}',
      )
   ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 14,
        },
  style=null,
)//10 graph
.addPanel(
  tablePanel.new(
    title='System Info',
    datasource='Prometheus',
    fontSize='90%',
    scroll=true,
    showHeader=true,
    pageSize=7,
    sort={
      "col":0,
      "desc":false,
    },
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
       "dateFormat": "YYYY-MM-DD HH:mm:ss",
       "decimals": 2,
       "link": false,
       "mappingType": 1,
       "pattern": "Time",
       "thresholds": [],
       "type": "hidden",
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
       "dateFormat": "YYYY-MM-DD HH:mm:ss",
       "decimals": 2,
       "mappingType": 1,
       "pattern": "Value",
       "thresholds": [],
       "type": "hidden",
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
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "__name__",
        "thresholds": [],
        "type": "hidden",
        "unit": "short"
      }
  )
  .addStyle(
    {
     "alias": "Domainname",
     "colorMode": null,
     "colors": [
       "rgba(245, 54, 54, 0.9)",
       "rgba(237, 129, 40, 0.89)",
       "rgba(50, 172, 45, 0.97)"
     ],
     "dateFormat": "YYYY-MM-DD HH:mm:ss",
     "decimals": 2,
     "mappingType": 1,
     "pattern": "domainname",
     "thresholds": [],
     "type": "hidden",
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
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "job",
      "thresholds": [],
      "type": "hidden",
      "unit": "short"
    }
  )
  .addStyle(
    {
      "alias": "Kernel",
      "colorMode": null,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(50, 172, 45, 0.97)"
      ],
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "release",
      "thresholds": [],
      "type": "number",
      "unit": "short"
    }
  )
  .addStyle(
   {
     "alias": "Hostname",
     "colorMode": null,
     "colors": [
       "rgba(245, 54, 54, 0.9)",
       "rgba(237, 129, 40, 0.89)",
       "rgba(50, 172, 45, 0.97)"
     ],
     "dateFormat": "YYYY-MM-DD HH:mm:ss",
     "decimals": 2,
     "mappingType": 1,
     "pattern": "nodename",
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
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "machine",
      "thresholds": [],
      "type": "hidden",
      "unit": "short"
    }
  )
  .addStyle(
    {
     "alias": "Instance",
     "colorMode": null,
     "colors": [
       "rgba(245, 54, 54, 0.9)",
       "rgba(237, 129, 40, 0.89)",
       "rgba(50, 172, 45, 0.97)"
     ],
     "dateFormat": "YYYY-MM-DD HH:mm:ss",
     "decimals": 2,
     "mappingType": 1,
     "pattern": "instance",
     "thresholds": [],
     "type": "hidden",
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
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "version",
      "thresholds": [],
      "type": "hidden",
      "unit": "short"
    }
  )
  .addStyle(
    {
        "alias": "System",
        "colorMode": null,
        "colors": [
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)"
        ],
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "sysname",
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
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "/.*_id/",
      "thresholds": [],
      "type": "hidden",
      "unit": "short"
    }
  )
  .addTarget(
    prometheus.target(
      'node_uname_info{node_name=~"$host"}',
      legendFormat='{{sysname}} | {{ release }} | {{domainname}}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      instant=true,
      format='table',
      step=300,
   )
   ),
  gridPos={
      "h": 8,
      "w": 24,
      "x": 0,
      "y": 21,
    },
    style=null,
)//12 table
.addPanel(
  tablePanel.new(
    title='MySQL Info',
    datasource='Prometheus',
    fontSize='90%',
    scroll=true,
    showHeader=true,
    pageSize=7,
    sort={
      "col":0,
      "desc":false,
    },
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
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "Time",
      "thresholds": [],
      "type": "hidden",
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
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "__name__",
      "thresholds": [],
      "type": "hidden",
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
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "innodb_version",
        "thresholds": [],
        "type": "hidden",
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
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "job",
      "thresholds": [],
      "type": "hidden",
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
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "Value",
      "thresholds": [],
      "type": "hidden",
      "unit": "short"
    }
  )
  .addStyle(
    {
        "alias": "Instance",
        "colorMode": null,
        "colors": [
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)"
        ],
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "instance",
        "thresholds": [],
        "type": "hidden",
        "unit": "short"
      }
  )
  .addStyle(
    {
      "alias": "Version",
      "colorMode": null,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(50, 172, 45, 0.97)"
      ],
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "version",
      "thresholds": [],
      "type": "number",
      "unit": "short"
    }
  )
  .addStyle(
    {
        "alias": "Details",
        "colorMode": null,
        "colors": [
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)"
        ],
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "version_comment",
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
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "/.*_id/",
      "thresholds": [],
      "type": "hidden",
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
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "/node_.*/",
        "thresholds": [],
        "type": "hidden",
        "unit": "short"
      }
  )
  .addTarget(
    prometheus.target(
      'mysql_version_info{node_name=~"$host"}',
      legendFormat='{{ instance }} | {{ version }} | {{ version_comment }}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      instant=true,
      format='table',
      step=300,
   )
   ),
  gridPos={
    "h": 8,
    "w": 24,
    "x": 0,
    "y": 29,
    },
    style=null,
)//13 table
