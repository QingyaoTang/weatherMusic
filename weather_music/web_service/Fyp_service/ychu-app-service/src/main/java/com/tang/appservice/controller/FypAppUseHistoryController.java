package com.tang.appservice.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.tang.appservice.domain.FypAppUseHistory;
import com.tang.appservice.service.IFypAppUseHistoryService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * app使用记录Controller
 * 
 * @author ruoyi
 * @date 2024-03-29
 */
@RestController
@RequestMapping("/appservice/history")
public class FypAppUseHistoryController extends BaseController
{
    @Autowired
    private IFypAppUseHistoryService fypAppUseHistoryService;

    /**
     * 查询app使用记录列表
     */
    @PreAuthorize("@ss.hasPermi('appservice:history:list')")
    @GetMapping("/list")
    public TableDataInfo list(FypAppUseHistory fypAppUseHistory)
    {
        startPage();
        List<FypAppUseHistory> list = fypAppUseHistoryService.selectFypAppUseHistoryList(fypAppUseHistory);
        return getDataTable(list);
    }

    /*用于app每隔20分钟调用一次，若不存在则插入一条记录，否则更新记录*/
    @Log(title = "app定时使用记录" , businessType = BusinessType.UPDATE)
    @PostMapping("/forAppRecord")
    public AjaxResult addOrUpForUseApp(@RequestBody FypAppUseHistory fypAppUseHistory)
    {
        int i = 0;
        final List<FypAppUseHistory> fypAppUseHistories = fypAppUseHistoryService.selectFypAppUseHistoryList(fypAppUseHistory);
        if (fypAppUseHistories.size() > 0){
            FypAppUseHistory fypAppUseHistoryGet = fypAppUseHistories.get(0);
            fypAppUseHistoryGet.setTime(fypAppUseHistoryGet.getTime() + 1);
            i = fypAppUseHistoryService.updateFypAppUseHistory(fypAppUseHistoryGet);
        }else{
            fypAppUseHistory.setTime(20l);
            i = fypAppUseHistoryService.insertFypAppUseHistory(fypAppUseHistory);
        }
        return toAjax(i);
    }
    /**
     * 查询app使用记录列表
     */
    @GetMapping("/app/list")
    public AjaxResult appList(FypAppUseHistory fypAppUseHistory)
    {
        List<FypAppUseHistory> list = fypAppUseHistoryService.selectFypAppUseHistoryList(fypAppUseHistory);
        return AjaxResult.success(list);
    }

    /**
     * 导出app使用记录列表
     */
    @PreAuthorize("@ss.hasPermi('appservice:history:export')")
    @Log(title = "app使用记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, FypAppUseHistory fypAppUseHistory)
    {
        List<FypAppUseHistory> list = fypAppUseHistoryService.selectFypAppUseHistoryList(fypAppUseHistory);
        ExcelUtil<FypAppUseHistory> util = new ExcelUtil<FypAppUseHistory>(FypAppUseHistory.class);
        util.exportExcel(response, list, "app使用记录数据");
    }

    /**
     * 获取app使用记录详细信息
     */
    @GetMapping(value = "/{historyId}")
    public AjaxResult getInfo(@PathVariable("historyId") Long historyId)
    {
        return success(fypAppUseHistoryService.selectFypAppUseHistoryByHistoryId(historyId));
    }

    /**
     * 新增app使用记录
     */
    @Log(title = "app使用记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody FypAppUseHistory fypAppUseHistory)
    {
        return toAjax(fypAppUseHistoryService.insertFypAppUseHistory(fypAppUseHistory));
    }

    /**
     * 修改app使用记录
     */
    @Log(title = "app使用记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody FypAppUseHistory fypAppUseHistory)
    {
        return toAjax(fypAppUseHistoryService.updateFypAppUseHistory(fypAppUseHistory));
    }

    /**
     * 删除app使用记录
     */
    @PreAuthorize("@ss.hasPermi('appservice:history:remove')")
    @Log(title = "app使用记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{historyIds}")
    public AjaxResult remove(@PathVariable Long[] historyIds)
    {
        return toAjax(fypAppUseHistoryService.deleteFypAppUseHistoryByHistoryIds(historyIds));
    }
}
