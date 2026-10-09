{* LWB Theme — panneaux latéraux (menus de page), toujours dépliés · LEWEBMAX Admin *}
{foreach $sidebar as $item}
    <div menuItemName="{$item->getName()}" class="lwx-panel card-sidebar{if $item->getClass()} {$item->getClass()}{/if}"{if $item->getAttribute('id')} id="{$item->getAttribute('id')}"{/if}>
        <div class="lwx-panel-head">
            {if $item->hasIcon()}<i class="{$item->getIcon()}"></i>{/if}
            <span>{$item->getLabel()}</span>
            {if $item->hasBadge()}<em class="lwx-badge lwx-badge-info">{$item->getBadge()}</em>{/if}
        </div>
        {if $item->hasBodyHtml()}
            <div class="lwx-panel-body">
                {$item->getBodyHtml()}
            </div>
        {/if}
        {if $item->hasChildren()}
            <div class="list-group lwx-panel-list{if $item->getChildrenAttribute('class')} {$item->getChildrenAttribute('class')}{/if}" role="tablist">
                {foreach $item->getChildren() as $childItem}
                    {if $childItem->getUri()}
                        <a menuItemName="{$childItem->getName()}"
                           href="{$childItem->getUri()}"
                           class="list-group-item list-group-item-action lwx-panel-link{if $childItem->isDisabled()} disabled{/if}{if $childItem->getClass()} {$childItem->getClass()}{/if}{if $childItem->isCurrent()} active{/if}"
                           {if $childItem->getAttribute('dataToggleTab')}data-toggle="list" role="tab"{/if}
                           {assign "customActionData" $childItem->getAttribute('dataCustomAction')}
                           {if is_array($customActionData)}data-active="{$customActionData['active']}" data-identifier="{$customActionData['identifier']}" data-serviceid="{$customActionData['serviceid']}"{/if}
                           {if $childItem->getAttribute('target')}target="{$childItem->getAttribute('target')}"{/if}
                           id="{$childItem->getId()}">
                            <div class="sidebar-menu-item-wrapper">
                                <div class="sidebar-menu-item-icon-wrapper">
                                    {if is_array($customActionData)}
                                        <span class="loading" style="display: none;"><i class="fas fa-spinner fa-spin fa-fw"></i></span>
                                    {/if}
                                    <i class="{if $childItem->hasIcon()}{$childItem->getIcon()}{else}far fa-angle-right{/if} sidebar-menu-item-icon"></i>
                                </div>
                                <div class="sidebar-menu-item-label">{$childItem->getLabel()}</div>
                                {if $childItem->hasBadge()}
                                    <div class="sidebar-menu-item-badge"><span class="badge">{$childItem->getBadge()}</span></div>
                                {/if}
                            </div>
                        </a>
                    {else}
                        <div menuItemName="{$childItem->getName()}" class="list-group-item lwx-panel-text{if $childItem->getClass()} {$childItem->getClass()}{/if}" id="{$childItem->getId()}">
                            {if $childItem->hasIcon()}<i class="{$childItem->getIcon()}"></i>{/if}
                            <span>{$childItem->getLabel()}</span>
                            {if $childItem->hasBadge()}<span class="badge">{$childItem->getBadge()}</span>{/if}
                        </div>
                    {/if}
                {/foreach}
            </div>
        {/if}
        {if $item->hasFooterHtml()}
            <div class="lwx-panel-foot">
                {$item->getFooterHtml()}
            </div>
        {/if}
    </div>
{/foreach}
