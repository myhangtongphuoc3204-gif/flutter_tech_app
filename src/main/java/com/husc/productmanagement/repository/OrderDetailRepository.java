package com.husc.productmanagement.repository;

import com.husc.productmanagement.entity.OrderDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import org.springframework.data.jpa.repository.Query;

@Repository
public interface OrderDetailRepository extends JpaRepository<OrderDetail, Integer> {

    List<OrderDetail> findByOrderId(Integer orderId);

    List<OrderDetail> findByProductId(Integer productId);

    @Query("SELECT p.name, p.image, SUM(od.quantity) FROM OrderDetail od JOIN od.product p GROUP BY p.name, p.image ORDER BY SUM(od.quantity) DESC")
    List<Object[]> findBestSellingProductsRaw(org.springframework.data.domain.Pageable pageable);

    @Query("SELECT c.name, SUM(od.quantity) FROM OrderDetail od JOIN od.product p JOIN p.category c GROUP BY c.name ORDER BY SUM(od.quantity) DESC")
    List<Object[]> findBestSellingCategoriesRaw(org.springframework.data.domain.Pageable pageable);
}
