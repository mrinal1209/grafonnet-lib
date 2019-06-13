{
  dashboards(
    title,
    tags,
    asDropdown=true,
    includeVars=false,
    keepTime=false,
    icon=null,
    url=null,
    targetBlank=false,
    type='dashboards',
  )::
    {
      includeVars: includeVars,
      keepTime: keepTime,
      tags: tags,
      title: title,
      type: type,
      targetBlank: targetBlank,
      [if asDropdown != false then 'asDropdown']: asDropdown,
      [if icon != null then 'icon']: icon,
      [if url != null then 'url']: url,
    },
}
