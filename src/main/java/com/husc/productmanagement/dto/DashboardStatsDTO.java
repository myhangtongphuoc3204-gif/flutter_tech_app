package com.husc.productmanagement.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Data
public class DashboardStatsDTO {
    private BigDecimal monthlyRevenue;
    private Map<String, Long> orderStatusCounts;
    private List<ProductSalesDTO> bestSellingProducts;
    private List<CategorySalesDTO> bestSellingCategories;
}
