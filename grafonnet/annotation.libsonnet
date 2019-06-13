{
  default::
    {
      builtIn: 1,
      datasource: '-- Grafana --',
      enable: true,
      hide: true,
      iconColor: 'rgba(0, 211, 255, 1)',
      name: 'Annotations & Alerts',
      type: 'dashboard',
    },
  datasource(
    name,
    datasource,
    expr=null,
    enable=true,
    hide=false,
    iconColor='rgba(255, 96, 96, 1)',
    tags=[],
    type='tags',
    builtIn=null,
    limit=null
  )::
    {
      datasource: datasource,
      enable: enable,
      [if expr != null then 'expr']: expr,
      [if limit != null then 'limit']: limit,
      hide: hide,
      iconColor: iconColor,
      name: name,
      showIn: 0,
      tags: tags,
      type: type,
      [if builtIn != null then 'builtIn']: builtIn,
    },
}
