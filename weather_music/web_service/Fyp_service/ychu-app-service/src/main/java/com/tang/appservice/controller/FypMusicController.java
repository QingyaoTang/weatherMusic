package com.tang.appservice.controller;

import java.util.List;
import java.util.Random;
import javax.servlet.http.HttpServletResponse;

import com.ruoyi.common.utils.SecurityUtils;
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
import com.tang.appservice.domain.FypMusic;
import com.tang.appservice.service.IFypMusicService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 音频信息Controller
 * 
 * @author ruoyi
 * @date 2024-03-23
 */
@RestController
@RequestMapping("/appservice/music")
public class FypMusicController extends BaseController
{
    @Autowired
    private IFypMusicService fypMusicService;

    /**
     * 查询音频信息列表
     */
    @PreAuthorize("@ss.hasPermi('appservice:music:list')")
    @GetMapping("/list")
    public TableDataInfo list(FypMusic fypMusic)
    {
        startPage();
        List<FypMusic> list = fypMusicService.selectFypMusicList(fypMusic);
        return getDataTable(list);
    }
    /**
     * 查询音频信息列表
     */
    @GetMapping("/app/list")
    public AjaxResult appList(FypMusic fypMusic)
    {
        List<FypMusic> list = fypMusicService.selectFypMusicList(fypMusic);
        return AjaxResult.success(list);
    }

    /**
     * 查询音频信息列表
     */
    @GetMapping("/app/mylist")
    public AjaxResult appMyList(FypMusic fypMusic)
    {
        fypMusic.setCreateBy(SecurityUtils.getUsername());
        List<FypMusic> list = fypMusicService.selectFypMusicList(fypMusic);
        return AjaxResult.success(list);
    }

    /**
     * 导出音频信息列表
     */
    @PreAuthorize("@ss.hasPermi('appservice:music:export')")
    @Log(title = "音频信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, FypMusic fypMusic)
    {
        List<FypMusic> list = fypMusicService.selectFypMusicList(fypMusic);
        ExcelUtil<FypMusic> util = new ExcelUtil<FypMusic>(FypMusic.class);
        util.exportExcel(response, list, "音频信息数据");
    }
    /**
     * 查询音频信息列表
     */
    @GetMapping("/randomOne")
    public AjaxResult listRandomOne(FypMusic fypMusic)
    {
        List<FypMusic> list = fypMusicService.selectFypMusicList(fypMusic);
        Random random = new Random();
        FypMusic music = list.get(random.nextInt(list.size()));
        return success(music);
    }


    /**
     * 获取音频信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('appservice:music:query')")
    @GetMapping(value = "/{musicId}")
    public AjaxResult getInfo(@PathVariable("musicId") Long musicId)
    {
        return success(fypMusicService.selectFypMusicByMusicId(musicId));
    }

    /**
     * 新增音频信息
     */
    @Log(title = "音频信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody FypMusic fypMusic)
    {
        return toAjax(fypMusicService.insertFypMusic(fypMusic));
    }

    /**
     * 修改音频信息
     */
    @PreAuthorize("@ss.hasPermi('appservice:music:edit')")
    @Log(title = "音频信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody FypMusic fypMusic)
    {
        return toAjax(fypMusicService.updateFypMusic(fypMusic));
    }

    /**
     * 删除音频信息
     */
    @PreAuthorize("@ss.hasPermi('appservice:music:remove')")
    @Log(title = "音频信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{musicIds}")
    public AjaxResult remove(@PathVariable Long[] musicIds)
    {
        return toAjax(fypMusicService.deleteFypMusicByMusicIds(musicIds));
    }
}
