package com.husc.productmanagement.controller;

import com.husc.productmanagement.dto.DashboardStatsDTO;
import com.husc.productmanagement.entity.Order;
import com.husc.productmanagement.repository.OrderDetailRepository;
import com.husc.productmanagement.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;

    @GetMapping("/stats")
    public ResponseEntity<?> getDashboardStats() {
        try {
            DashboardStatsDTO stats = new DashboardStatsDTO();

            // 1. Total Revenue (All time, DELIVERED only)
            BigDecimal revenue = orderRepository.sumTotalAmountByStatus(Order.Status.DELIVERED);
            stats.setMonthlyRevenue(revenue != null ? revenue : BigDecimal.ZERO);

            // 2. Order Status Counts
            List<Object[]> statusCounts = orderRepository.countOrdersByStatus();
            Map<String, Long> countsMap = new HashMap<>();
            if (statusCounts != null) {
                for (Object[] row : statusCounts) {
                    if (row[0] != null && row[1] != null) {
                       countsMap.put(row[0].toString(), (Long) row[1]);
                    }
                }
            }
            stats.setOrderStatusCounts(countsMap);

            // 3. Best Selling Products (Top 3)
            List<Object[]> productRows = orderDetailRepository.findBestSellingProductsRaw(PageRequest.of(0, 3));
            List<com.husc.productmanagement.dto.ProductSalesDTO> topProducts = new java.util.ArrayList<>();
            if (productRows != null) {
                for (Object[] row : productRows) {
                    String name = (String) row[0];
                    String image = (String) row[1];
                    Long total = ((Number) row[2]).longValue(); // Safe cast for SUM result
                    topProducts.add(new com.husc.productmanagement.dto.ProductSalesDTO(name, image, total));
                }
            }
            stats.setBestSellingProducts(topProducts);

            // 4. Best Selling Categories (Top 3)
            List<Object[]> categoryRows = orderDetailRepository.findBestSellingCategoriesRaw(PageRequest.of(0, 3));
            List<com.husc.productmanagement.dto.CategorySalesDTO> topCategories = new java.util.ArrayList<>();
            if (categoryRows != null) {
                for (Object[] row : categoryRows) {
                    String name = (String) row[0];
                    Long total = ((Number) row[1]).longValue(); // Safe cast for SUM result
                    topCategories.add(new com.husc.productmanagement.dto.CategorySalesDTO(name, total));
                }
            }
            stats.setBestSellingCategories(topCategories);

            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            e.printStackTrace();
            java.io.StringWriter sw = new java.io.StringWriter();
            java.io.PrintWriter pw = new java.io.PrintWriter(sw);
            e.printStackTrace(pw);
            return ResponseEntity.internalServerError().body(Map.of("success", false, "message", "Error: " + sw.toString()));
        }
    }
}
