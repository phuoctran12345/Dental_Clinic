//package Filter;
//
//import java.io.IOException;
//import jakarta.servlet.Filter;
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.FilterConfig;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.ServletRequest;
//import jakarta.servlet.ServletResponse;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
///**
// * 🔤 ENCODING FILTER
// * Filter đảm bảo encoding UTF-8 cho toàn bộ ứng dụng
// * Hỗ trợ tiếng Việt hiển thị đúng
// * 
// * @author TranHongPhuoc
// */
//@WebFilter(filterName = "EncodingFilter", urlPatterns = {"/*"})
//public class EncodingFilter implements Filter {
//    
//    private static final String ENCODING = "UTF-8";
//    
//    public EncodingFilter() {}
//
//    @Override
//    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
//            throws IOException, ServletException {
//        
//        HttpServletRequest request = (HttpServletRequest) req;
//        HttpServletResponse response = (HttpServletResponse) res;
//        
//        // Set encoding cho request và response
//        request.setCharacterEncoding(ENCODING);
//        response.setCharacterEncoding(ENCODING);
//        response.setContentType("text/html; charset=" + ENCODING);
//        
//        // Tiếp tục filter chain
//        chain.doFilter(req, res);
//    }
//
//    @Override
//    public void init(FilterConfig filterConfig) {
//        System.out.println("🔤 Encoding Filter initialized with UTF-8");
//    }
//
//    @Override
//    public void destroy() {
//        System.out.println("🔤 Encoding Filter destroyed");
//    }
//} 