package com.tang.appservice.service;

import java.util.List;
import com.tang.appservice.domain.FypMusic;

/**
 * 音频信息Service接口
 * 
 * @author ruoyi
 * @date 2024-03-23
 */
public interface IFypMusicService 
{
    /**
     * 查询音频信息
     * 
     * @param musicId 音频信息主键
     * @return 音频信息
     */
    public FypMusic selectFypMusicByMusicId(Long musicId);

    /**
     * 查询音频信息列表
     * 
     * @param fypMusic 音频信息
     * @return 音频信息集合
     */
    public List<FypMusic> selectFypMusicList(FypMusic fypMusic);

    /**
     * 新增音频信息
     * 
     * @param fypMusic 音频信息
     * @return 结果
     */
    public int insertFypMusic(FypMusic fypMusic);

    /**
     * 修改音频信息
     * 
     * @param fypMusic 音频信息
     * @return 结果
     */
    public int updateFypMusic(FypMusic fypMusic);

    /**
     * 批量删除音频信息
     * 
     * @param musicIds 需要删除的音频信息主键集合
     * @return 结果
     */
    public int deleteFypMusicByMusicIds(Long[] musicIds);

    /**
     * 删除音频信息信息
     * 
     * @param musicId 音频信息主键
     * @return 结果
     */
    public int deleteFypMusicByMusicId(Long musicId);
}
