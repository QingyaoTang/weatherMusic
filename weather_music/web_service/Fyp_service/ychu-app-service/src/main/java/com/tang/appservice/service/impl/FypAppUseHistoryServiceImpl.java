package com.tang.appservice.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.tang.appservice.mapper.FypAppUseHistoryMapper;
import com.tang.appservice.domain.FypAppUseHistory;
import com.tang.appservice.service.IFypAppUseHistoryService;

/**
 * app使用记录Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-03-29
 */
@Service
public class FypAppUseHistoryServiceImpl implements IFypAppUseHistoryService 
{
    @Autowired
    private FypAppUseHistoryMapper fypAppUseHistoryMapper;

    /**
     * 查询app使用记录
     * 
     * @param historyId app使用记录主键
     * @return app使用记录
     */
    @Override
    public FypAppUseHistory selectFypAppUseHistoryByHistoryId(Long historyId)
    {
        return fypAppUseHistoryMapper.selectFypAppUseHistoryByHistoryId(historyId);
    }

    /**
     * 查询app使用记录列表
     * 
     * @param fypAppUseHistory app使用记录
     * @return app使用记录
     */
    @Override
    public List<FypAppUseHistory> selectFypAppUseHistoryList(FypAppUseHistory fypAppUseHistory)
    {
        return fypAppUseHistoryMapper.selectFypAppUseHistoryList(fypAppUseHistory);
    }

    /**
     * 新增app使用记录
     * 
     * @param fypAppUseHistory app使用记录
     * @return 结果
     */
    @Override
    public int insertFypAppUseHistory(FypAppUseHistory fypAppUseHistory)
    {
        fypAppUseHistory.setCreateBy(SecurityUtils.getUsername());
        fypAppUseHistory.setCreateTime(DateUtils.getNowDate());
        return fypAppUseHistoryMapper.insertFypAppUseHistory(fypAppUseHistory);
    }

    /**
     * 修改app使用记录
     * 
     * @param fypAppUseHistory app使用记录
     * @return 结果
     */
    @Override
    public int updateFypAppUseHistory(FypAppUseHistory fypAppUseHistory)
    {
        fypAppUseHistory.setUpdateBy(SecurityUtils.getUsername());
        fypAppUseHistory.setUpdateTime(DateUtils.getNowDate());
        return fypAppUseHistoryMapper.updateFypAppUseHistory(fypAppUseHistory);
    }

    /**
     * 批量删除app使用记录
     * 
     * @param historyIds 需要删除的app使用记录主键
     * @return 结果
     */
    @Override
    public int deleteFypAppUseHistoryByHistoryIds(Long[] historyIds)
    {
        return fypAppUseHistoryMapper.deleteFypAppUseHistoryByHistoryIds(historyIds);
    }

    /**
     * 删除app使用记录信息
     * 
     * @param historyId app使用记录主键
     * @return 结果
     */
    @Override
    public int deleteFypAppUseHistoryByHistoryId(Long historyId)
    {
        return fypAppUseHistoryMapper.deleteFypAppUseHistoryByHistoryId(historyId);
    }
}
