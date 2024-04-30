package com.tang.appservice.service;

import java.util.List;
import com.tang.appservice.domain.FypAppUseHistory;

/**
 * app使用记录Service接口
 * 
 * @author ruoyi
 * @date 2024-03-29
 */
public interface IFypAppUseHistoryService 
{
    /**
     * 查询app使用记录
     * 
     * @param historyId app使用记录主键
     * @return app使用记录
     */
    public FypAppUseHistory selectFypAppUseHistoryByHistoryId(Long historyId);

    /**
     * 查询app使用记录列表
     * 
     * @param fypAppUseHistory app使用记录
     * @return app使用记录集合
     */
    public List<FypAppUseHistory> selectFypAppUseHistoryList(FypAppUseHistory fypAppUseHistory);

    /**
     * 新增app使用记录
     * 
     * @param fypAppUseHistory app使用记录
     * @return 结果
     */
    public int insertFypAppUseHistory(FypAppUseHistory fypAppUseHistory);

    /**
     * 修改app使用记录
     * 
     * @param fypAppUseHistory app使用记录
     * @return 结果
     */
    public int updateFypAppUseHistory(FypAppUseHistory fypAppUseHistory);

    /**
     * 批量删除app使用记录
     * 
     * @param historyIds 需要删除的app使用记录主键集合
     * @return 结果
     */
    public int deleteFypAppUseHistoryByHistoryIds(Long[] historyIds);

    /**
     * 删除app使用记录信息
     * 
     * @param historyId app使用记录主键
     * @return 结果
     */
    public int deleteFypAppUseHistoryByHistoryId(Long historyId);
}
