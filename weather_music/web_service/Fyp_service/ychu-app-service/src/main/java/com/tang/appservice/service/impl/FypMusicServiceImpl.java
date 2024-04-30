package com.tang.appservice.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import org.apache.catalina.security.SecurityUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.tang.appservice.mapper.FypMusicMapper;
import com.tang.appservice.domain.FypMusic;
import com.tang.appservice.service.IFypMusicService;

/**
 * 音频信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-03-23
 */
@Service
public class FypMusicServiceImpl implements IFypMusicService 
{
    @Autowired
    private FypMusicMapper fypMusicMapper;

    /**
     * 查询音频信息
     * 
     * @param musicId 音频信息主键
     * @return 音频信息
     */
    @Override
    public FypMusic selectFypMusicByMusicId(Long musicId)
    {
        return fypMusicMapper.selectFypMusicByMusicId(musicId);
    }

    /**
     * 查询音频信息列表
     * 
     * @param fypMusic 音频信息
     * @return 音频信息
     */
    @Override
    public List<FypMusic> selectFypMusicList(FypMusic fypMusic)
    {
        return fypMusicMapper.selectFypMusicList(fypMusic);
    }

    /**
     * 新增音频信息
     * 
     * @param fypMusic 音频信息
     * @return 结果
     */
    @Override
    public int insertFypMusic(FypMusic fypMusic)
    {
        fypMusic.setCreateTime(DateUtils.getNowDate());
        fypMusic.setCreateBy(SecurityUtils.getUsername());
        return fypMusicMapper.insertFypMusic(fypMusic);
    }

    /**
     * 修改音频信息
     * 
     * @param fypMusic 音频信息
     * @return 结果
     */
    @Override
    public int updateFypMusic(FypMusic fypMusic)
    {
        fypMusic.setUpdateTime(DateUtils.getNowDate());
        fypMusic.setUpdateBy(SecurityUtils.getUsername());
        return fypMusicMapper.updateFypMusic(fypMusic);
    }

    /**
     * 批量删除音频信息
     * 
     * @param musicIds 需要删除的音频信息主键
     * @return 结果
     */
    @Override
    public int deleteFypMusicByMusicIds(Long[] musicIds)
    {
        return fypMusicMapper.deleteFypMusicByMusicIds(musicIds);
    }

    /**
     * 删除音频信息信息
     * 
     * @param musicId 音频信息主键
     * @return 结果
     */
    @Override
    public int deleteFypMusicByMusicId(Long musicId)
    {
        return fypMusicMapper.deleteFypMusicByMusicId(musicId);
    }
}
