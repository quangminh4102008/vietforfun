package com.tiengviet.utils;

import com.tiengviet.entity.BlogPost;
import java.util.ArrayList;
import java.util.List;

public class BlogData {
    private static final List<BlogPost> posts = new ArrayList<>();

    // Sử dụng static block để khởi tạo dữ liệu một lần duy nhất
    static {
        // --- BÀI VIẾT GỐC ---
        posts.add(new BlogPost(
                "Mastering Vietnamese Tones: A Beginner's Guide",
                "The 6 Vietnamese tones can be tricky, but they are the key to being understood...",
                "https://i.ytimg.com/vi/Ws8iPFtZAbo/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLA8ONB8fkY02lVWgCNdu5xt1Twp1w",
                "Pronunciation",
                "mastering-vietnamese-tones",
                "<p>The six Vietnamese tones are what make the language so unique and melodic. However, they can be a real challenge for new learners. Don't worry, we're here to help!</p><h2>The 6 Tones</h2><p>Here is a simple breakdown of each tone...</p>"
        ));
        posts.add(new BlogPost(
                "How to Order Street Food in Vietnam Like a Local",
                "Feeling hungry? Learn essential phrases to confidently order classics like Phở, Bánh Mì...",
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9p_IwK9M3OE9pRS4_hvZXtwJctC1_9-2gTQ&s",
                "Culture & Food",
                "order-street-food-like-a-local",
                "<p>Vietnamese street food is famous around the world. But how do you order it? Here are some essential phrases:</p><ul><li>Cho tôi một bát phở: Give me one bowl of Pho.</li><li>Bao nhiêu tiền?: How much is it?</li></ul>"
        ));
        posts.add(new BlogPost(
                "\"Anh, Chị, Em\": A Simple Guide to Vietnamese Pronouns",
                "Unlike English, Vietnamese pronouns change based on age and relationship...",
                "https://learnvietnameseeasy.com/wp-content/uploads/2021/04/how-to-use-personal-pronouns-in-vietnamese-learn-vietnamese-easy.jpg",
                "Grammar",
                "vietnamese-pronouns-guide",
                "<p>Vietnamese pronouns are all about respect and relationships. It's not as complicated as it seems. Here is a simple table to help you get started...</p>"
        ));

        // --- 5 BÀI VIẾT MỚI ĐƯỢC THÊM VÀO ---
        posts.add(new BlogPost(
                "Counting in Vietnamese: From 1 to 1,000,000",
                "Learn the system of counting in Vietnamese, including the special rules for numbers ending in 1 and 5.",
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTb2F5fV0QIRPSF1peH5QWpPtCDMsRWKnMjyw&s",
                "Vocabulary",
                "counting-in-vietnamese",
                "<h2>Counting from 1 to 10</h2><p>The basics are simple: Một (1), Hai (2), Ba (3), Bốn (4), Năm (5), Sáu (6), Bảy (7), Tám (8), Chín (9), Mười (10).</p><h2>Important Rules</h2><p>Things get interesting after 10! The two most important rules to remember are for numbers ending in 1 and 5.</p><ul><li>Use <strong>mốt</strong> for numbers ending in 1 (e.g., hai mươi mốt - 21).</li><li>Use <strong>lăm</strong> for numbers ending in 5 (e.g., ba mươi lăm - 35).</li></ul>"
        ));
        posts.add(new BlogPost(
                "Tết Holiday: Understanding Vietnamese Lunar New Year",
                "Tết is the most important celebration in Vietnamese culture. Discover its rich traditions, foods, and greetings.",
                "https://image.vietnam.travel/sites/default/files/styles/top_banner/public/2021-02/tet%20festival%20vietnam.jpg?itok=V_bxjqQz",
                "Culture & Food",
                "tet-lunar-new-year",
                "<p>Tết Nguyên Đán, or Tết for short, is the Vietnamese Lunar New Year. It's a time for family reunions, honoring ancestors, and celebrating new beginnings.</p><h2>Key Traditions</h2><ul><li><strong>Bánh Chưng:</strong> A traditional sticky rice cake that is essential to the holiday.</li><li><strong>Lì Xì:</strong> Giving lucky money in red envelopes to children and elders.</li><li><strong>Hoa Mai & Hoa Đào:</strong> Apricot and peach blossoms that symbolize luck and prosperity.</li></ul><p>The common greeting is 'Chúc Mừng Năm Mới' (Happy New Year)!</p>"
        ));
        posts.add(new BlogPost(
                "Building Your First Vietnamese Sentences: S-V-O",
                "The basic sentence structure in Vietnamese is Subject-Verb-Object, just like in English, but with a few key differences.",
                "https://i.ytimg.com/vi/6DSozfm3qy0/maxresdefault.jpg",
                "Grammar",
                "basic-vietnamese-sentence-structure",
                "<h2>The S-V-O Rule</h2><p>The core of a Vietnamese sentence is simple: Subject - Verb - Object.</p><p>Example: <strong>Tôi (I) ăn (eat) phở (pho).</strong></p><h2>Adjectives Come After Nouns</h2><p>This is a key difference from English. The adjective (describing word) always comes after the noun it describes.</p><p>Example: <strong>Ngôi nhà (house) màu xanh (blue).</strong> This literally translates to 'house color blue'.</p>"
        ));
        posts.add(new BlogPost(
                "The 5 Ws of Vietnamese: How to Ask Questions",
                "Mastering question words is the fastest way to start having real conversations. Learn the 'who, what, where, when, why' of Vietnamese.",
                "https://images.twinkl.co.uk/tw1n/image/private/t_630/image_repo/27/16/t-m-471-who-what-where-when-why-and-how-prompt-posters-_ver_1.jpg",
                "Grammar",
                "how-to-ask-questions-in-vietnamese",
                "<p>Asking questions is essential for communication. Here are the basic question words you need to know:</p><ul><li><strong>Cái gì?</strong> - What?</li><li><strong>Ở đâu?</strong> - Where?</li><li><strong>Ai?</strong> - Who?</li><li><strong>Khi nào?</strong> - When?</li><li><strong>Tại sao?</strong> - Why?</li><li><strong>Như thế nào?</strong> - How?</li></ul><p>Simply place these words at the end of a statement to turn it into a question. Example: 'Bạn đi <strong>đâu</strong>?' (You go where?) - Where are you going?</p>"
        ));
        posts.add(new BlogPost(
                "A Coffee Lover's Guide to Vietnam",
                "Vietnamese coffee is more than a drink; it's a culture. Learn about the different types, from 'cà phê sữa đá' to the famous 'cà phê trứng'.",
                "https://cdn.shopify.com/s/files/1/0600/9710/1877/articles/Blog-Post-1-1024x576-1-980x576.jpg?v=1697027695",
                "Culture & Food",
                "vietnamese-coffee-guide",
                "<h2>The Phin Filter</h2><p>Traditional Vietnamese coffee is brewed using a small metal drip filter called a 'phin', which produces a very strong, rich coffee.</p><h2>Must-Try Coffees</h2><ul><li><strong>Cà phê sữa đá:</strong> The famous iced coffee with sweetened condensed milk.</li><li><strong>Cà phê đen đá:</strong> Iced black coffee (can be ordered with or without sugar).</li><li><strong>Cà phê trứng:</strong> A unique Hanoi specialty made with egg yolks, sugar, and condensed milk, whipped into a creamy froth.</li></ul>"
        ));
    }

    public static List<BlogPost> getPosts() {
        return posts;
    }

    public static BlogPost findPostBySlug(String slug) {
        for (BlogPost post : posts) {
            if (post.getSlug().equals(slug)) {
                return post;
            }
        }
        return null; // Trả về null nếu không tìm thấy
    }
}