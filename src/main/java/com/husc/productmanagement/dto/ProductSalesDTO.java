package com.husc.productmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductSalesDTO {
    private String name;
    private String image;
    private Long totalSold;
}
