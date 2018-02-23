{* $Id: tiki-list_comments.tpl 57783 2016-03-05 18:04:25Z jonnybradley $ *}
{title help="comments" admpage="comments"}{$title}{/title}

{if $comments or ($find ne '') or count($show_types) gt 0 or isset($smarty.request.findfilter_approved)}
	<div class="col-md-6">
		{include file='find.tpl' types=$show_types find_type=$selected_types types_tag='checkbox' filters=$filters filter_names=$filter_names filter_values=$filter_values}
	</div>
{/if}

{if $comments}
	<form name="checkboxes_on" method="post" action="tiki-list_comments.php">
	{query _type='form_input'}
{/if}

{assign var=numbercol value=2}

{* Use css menus as fallback for item dropdown action menu if javascript is not being used *}
{if $prefs.javascript_enabled !== 'y'}
	{$js = 'n'}
	{$libeg = '<li>'}
	{$liend = '</li>'}
{else}
	{$js = 'y'}
	{$libeg = ''}
	{$liend = ''} 
{/if}
		<div class="{if $js === 'y'}table-responsive{/if} comment-table"> {*the table-responsive class cuts off dropdown menus *}
<table class="table table-striped table-hover">
	<tr>
		{if $comments}
			<th>
			</th>
		{/if}
		<th></th>

		{foreach key=headerKey item=headerName from=$headers}
			<th>
				{assign var=numbercol value=$numbercol+1}
				{self_link _sort_arg="sort_mode" _sort_field=$headerKey}{tr}{$headerName}{/tr}{/self_link}
			</th>
		{/foreach}
		<th></th>
	</tr>


	{section name=ix loop=$comments}{assign var=id value=$comments[ix].threadId}


		{capture name=over_more_info}
			{strip}
				{foreach from=$more_info_headers key=headerKey item=headerName}
					{if (isset($comments[ix].$headerKey))}
						{assign var=val value=$comments[ix].$headerKey}
						{$libeg}<b>{tr}{$headerName}{/tr}</b>: {$val}{$liend}
					{/if}
				{/foreach}
			{/strip}
		{/capture} 

		<tr class="{cycle}{if $prefs.feature_comments_moderation eq 'y'} post-approved-{$comments[ix].approved}{/if}">
      <td></td>
			<td class="action"></td>

			{foreach key=headerKey item=headerName from=$headers}{assign var=val value=$comments[ix].$headerKey}
				<td {if $headerKey eq 'data'}{popup caption=$comments[ix].title|escape:"javascript"|escape:"html" text=$comments[ix].parsed|escape:"javascript"|escape:"html"}{/if}>
					<span> {* span is used for some themes CSS opacity on some cells content *}
						{if $headerKey eq 'title'}
							<a href="{$comments[ix].href}" title="{$val|escape}">
								{if !empty($val)}
									{$val|truncate:50:"...":true|escape}
								{else}
									{tr}(no title){/tr}
								{/if}
							</a>
						{elseif $headerKey eq 'objectType'}
							{tr}{$val|ucwords}{/tr}
						{elseif $headerKey eq 'object'}
							{$val|truncate:50:"...":true|escape}
						{elseif $headerKey eq 'data'}
							{$val|truncate:90:"...":true|escape}
						{elseif $headerKey eq 'commentDate'}
							{$val|tiki_short_datetime}
						{elseif $headerKey eq 'userName'}
							{$val|userlink}
						{else}
							{$val}
						{/if}
					</span>
				</td>
			{/foreach}

			<td>
			</td>
		</tr>
	{sectionelse}
		{norecords _colspan=$numbercol}
	{/section}
</table>
</div>

{pagination_links cant=$cant step=$maxRecords offset=$offset}{/pagination_links}
