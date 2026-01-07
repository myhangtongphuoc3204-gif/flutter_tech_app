package com.husc.productmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {

    private String token;
    private String type = "Bearer";
    private Integer userId;
    private String email;
    private String phone;
    private String name;
    private String role;

    public LoginResponse(String token, Integer userId, String email, String phone, String name, String role) {
        this.token = token;
        this.userId = userId;
        this.email = email;
        this.phone = phone;
        this.name = name;
        this.role = role;
    }
}
