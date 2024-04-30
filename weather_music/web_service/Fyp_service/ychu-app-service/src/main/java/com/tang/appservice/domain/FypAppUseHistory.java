package com.tang.appservice.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * app使用记录对象 fyp_app_use_history
 * 
 * @author ruoyi
 * @date 2024-03-29
 */
public class FypAppUseHistory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 记录id */
    private Long historyId;

    /** 时长单位分钟 */
    @Excel(name = "时长单位分钟")
    private Long time;

    /** 日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private String Date;

    public void setHistoryId(Long historyId) 
    {
        this.historyId = historyId;
    }

    public Long getHistoryId() 
    {
        return historyId;
    }
    public void setTime(Long time) 
    {
        this.time = time;
    }

    public Long getTime() 
    {
        return time;
    }
    public void setDate(String Date)
    {
        this.Date = Date;
    }

    public String getDate()
    {
        return Date;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("historyId", getHistoryId())
            .append("time", getTime())
            .append("Date", getDate())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
