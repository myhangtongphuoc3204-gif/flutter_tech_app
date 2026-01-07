package com.husc.productmanagement.repository;

import com.husc.productmanagement.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

@Repository
public interface OrderRepository extends JpaRepository<Order, Integer> {

    Optional<Order> findByOrderCode(String orderCode);

    List<Order> findByStatus(Order.Status status);

    List<Order> findByEmail(String email);

    List<Order> findByPhone(String phone);

    List<Order> findByCustomerNameContaining(String customerName);

    @Query("SELECT SUM(o.totalAmount) FROM Order o WHERE o.status = :status")
    java.math.BigDecimal sumTotalAmountByStatus(@Param("status") Order.Status status);

    @Query("SELECT o.status, COUNT(o) FROM Order o GROUP BY o.status")
    List<Object[]> countOrdersByStatus();
}
