package com.tang.appservice.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 音频信息对象 fyp_music
 * 
 * @author ruoyi
 * @date 2024-03-23
 */
public class FypMusic extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 音频ID */
    private Long musicId;

    /** 所属心情 0 happy，1 Stress 2sad 3angry 4bored 5tired 6dont know */
    @Excel(name = "所属心情 0 happy，1 Stress 2sad 3angry 4bored 5tired 6dont know")
    private Long weather;

    /** 音频名称 */
    @Excel(name = "音频名称")
    private String musicName;

    /** 音频地址 */
    @Excel(name = "音频地址")
    private String musicPath;


    public String getMusicName() {
        return musicName;
    }

    public void setMusicName(String musicName) {
        this.musicName = musicName;
    }

    public void setMusicId(Long musicId)
    {
        this.musicId = musicId;
    }

    public Long getMusicId() 
    {
        return musicId;
    }
    public void setWeather(Long weather) 
    {
        this.weather = weather;
    }

    public Long getWeather() 
    {
        return weather;
    }
    public void setMusicPath(String musicPath) 
    {
        this.musicPath = musicPath;
    }

    public String getMusicPath() 
    {
        return musicPath;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("musicId", getMusicId())
            .append("weather", getWeather())
                .append("musicName", getMusicName())
                .append("musicPath", getMusicPath())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
